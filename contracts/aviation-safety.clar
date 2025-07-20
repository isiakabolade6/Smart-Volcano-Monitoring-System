;; Aviation Safety Contract
;; Manages flight restrictions and ash cloud monitoring during volcanic activity

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u400))
(define-constant ERR-INVALID-INPUT (err u401))
(define-constant ERR-RESTRICTION-NOT-FOUND (err u402))

;; Alert level constants
(define-constant ALERT-GREEN u1)
(define-constant ALERT-YELLOW u2)
(define-constant ALERT-ORANGE u3)
(define-constant ALERT-RED u4)

;; Data Variables
(define-data-var next-restriction-id uint u1)
(define-data-var next-ash-report-id uint u1)
(define-data-var global-alert-level uint u1)

;; Data Maps
(define-map flight-restrictions
  { restriction-id: uint }
  {
    volcano-name: (string-ascii 100),
    center-lat: int,
    center-lon: int,
    radius: uint,
    min-altitude: uint,
    max-altitude: uint,
    start-time: uint,
    end-time: uint,
    active: bool,
    reason: (string-ascii 200)
  }
)

(define-map ash-cloud-reports
  { report-id: uint }
  {
    timestamp: uint,
    center-lat: int,
    center-lon: int,
    altitude: uint,
    density: uint,
    movement-direction: uint,
    movement-speed: uint,
    forecast-duration: uint,
    reporter: principal
  }
)

(define-map aviation-alerts
  { alert-id: (string-ascii 50) }
  {
    alert-level: uint,
    message: (string-ascii 500),
    issued-time: uint,
    valid-until: uint,
    affected-airports: (string-ascii 200),
    active: bool
  }
)

(define-map authorized-controllers
  { controller: principal }
  { authorized: bool }
)

;; Authorization Functions
(define-public (authorize-controller (controller principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-controllers { controller: controller } { authorized: true }))
  )
)

;; Flight Restriction Functions
(define-public (create-flight-restriction
  (volcano-name (string-ascii 100))
  (center-lat int)
  (center-lon int)
  (radius uint)
  (min-altitude uint)
  (max-altitude uint)
  (duration uint)
  (reason (string-ascii 200)))
  (let
    (
      (restriction-id (var-get next-restriction-id))
      (current-time (unwrap-panic (get-block-info? time (- block-height u1))))
      (is-authorized (default-to false (get authorized (map-get? authorized-controllers { controller: tx-sender }))))
    )
    (asserts! is-authorized ERR-NOT-AUTHORIZED)
    (asserts! (> radius u0) ERR-INVALID-INPUT)
    (asserts! (< min-altitude max-altitude) ERR-INVALID-INPUT)

    (map-set flight-restrictions
      { restriction-id: restriction-id }
      {
        volcano-name: volcano-name,
        center-lat: center-lat,
        center-lon: center-lon,
        radius: radius,
        min-altitude: min-altitude,
        max-altitude: max-altitude,
        start-time: current-time,
        end-time: (+ current-time duration),
        active: true,
        reason: reason
      }
    )

    (var-set next-restriction-id (+ restriction-id u1))
    (ok restriction-id)
  )
)

(define-public (update-restriction-status (restriction-id uint) (active bool))
  (let
    (
      (restriction-data (unwrap! (map-get? flight-restrictions { restriction-id: restriction-id }) ERR-RESTRICTION-NOT-FOUND))
      (is-authorized (default-to false (get authorized (map-get? authorized-controllers { controller: tx-sender }))))
    )
    (asserts! is-authorized ERR-NOT-AUTHORIZED)

    (ok (map-set flight-restrictions
      { restriction-id: restriction-id }
      (merge restriction-data { active: active })
    ))
  )
)

;; Ash Cloud Monitoring Functions
(define-public (report-ash-cloud
  (center-lat int)
  (center-lon int)
  (altitude uint)
  (density uint)
  (movement-direction uint)
  (movement-speed uint)
  (forecast-duration uint))
  (let
    (
      (report-id (var-get next-ash-report-id))
      (current-time (unwrap-panic (get-block-info? time (- block-height u1))))
      (is-authorized (default-to false (get authorized (map-get? authorized-controllers { controller: tx-sender }))))
    )
    (asserts! is-authorized ERR-NOT-AUTHORIZED)
    (asserts! (> altitude u0) ERR-INVALID-INPUT)
    (asserts! (<= movement-direction u360) ERR-INVALID-INPUT)

    (map-set ash-cloud-reports
      { report-id: report-id }
      {
        timestamp: current-time,
        center-lat: center-lat,
        center-lon: center-lon,
        altitude: altitude,
        density: density,
        movement-direction: movement-direction,
        movement-speed: movement-speed,
        forecast-duration: forecast-duration,
        reporter: tx-sender
      }
    )

    (var-set next-ash-report-id (+ report-id u1))
    (ok report-id)
  )
)

;; Aviation Alert Functions
(define-public (issue-aviation-alert
  (alert-id (string-ascii 50))
  (alert-level uint)
  (message (string-ascii 500))
  (valid-duration uint)
  (affected-airports (string-ascii 200)))
  (let
    (
      (current-time (unwrap-panic (get-block-info? time (- block-height u1))))
      (is-authorized (default-to false (get authorized (map-get? authorized-controllers { controller: tx-sender }))))
    )
    (asserts! is-authorized ERR-NOT-AUTHORIZED)
    (asserts! (and (>= alert-level u1) (<= alert-level u4)) ERR-INVALID-INPUT)

    (map-set aviation-alerts
      { alert-id: alert-id }
      {
        alert-level: alert-level,
        message: message,
        issued-time: current-time,
        valid-until: (+ current-time valid-duration),
        affected-airports: affected-airports,
        active: true
      }
    )

    (var-set global-alert-level (if (> alert-level (var-get global-alert-level)) alert-level (var-get global-alert-level)))
    (ok true)
  )
)

(define-public (cancel-aviation-alert (alert-id (string-ascii 50)))
  (let
    (
      (alert-data (unwrap! (map-get? aviation-alerts { alert-id: alert-id }) ERR-RESTRICTION-NOT-FOUND))
      (is-authorized (default-to false (get authorized (map-get? authorized-controllers { controller: tx-sender }))))
    )
    (asserts! is-authorized ERR-NOT-AUTHORIZED)

    (ok (map-set aviation-alerts
      { alert-id: alert-id }
      (merge alert-data { active: false })
    ))
  )
)

;; Read Functions
(define-read-only (get-flight-restriction (restriction-id uint))
  (map-get? flight-restrictions { restriction-id: restriction-id })
)

(define-read-only (get-ash-cloud-report (report-id uint))
  (map-get? ash-cloud-reports { report-id: report-id })
)

(define-read-only (get-aviation-alert (alert-id (string-ascii 50)))
  (map-get? aviation-alerts { alert-id: alert-id })
)

(define-read-only (get-global-alert-level)
  (var-get global-alert-level)
)

(define-read-only (is-controller-authorized (controller principal))
  (default-to false (get authorized (map-get? authorized-controllers { controller: controller })))
)

(define-read-only (check-flight-safety (lat int) (lon int) (altitude uint))
  (let
    (
      (current-time (unwrap-panic (get-block-info? time (- block-height u1))))
    )
    ;; This would check against active restrictions in a real implementation
    ;; For now, return safe if global alert level is green
    (if (is-eq (var-get global-alert-level) ALERT-GREEN)
      true
      false
    )
  )
)
