(add-to-load-path ".")
(use-modules (ice-9 rdelim)
             (ice-9 textual-ports)
             (ice-9 receive)
             (rnrs io ports))

;; helpers
(define (cat . args)
  (with-output-to-string (λ() (for-each display args))) )

(define (writeln . args)
  (display (apply cat args))
  (newline))

(define (ht->str ht)
  (cat "{"
       (string-join (hash-map->list (λ(key val) (cat key " " val)) ht) ", ")
       "}"))

(define-macro (def . vals)
  `(begin ,@(let loop ((p vals) (defs (list)))
              (if (or (null? p) (null? (cdr p)))
                (reverse defs)
                (loop (cddr p) (cons `(define ,(car p) ,(cadr p)) defs))))))

(define-macro (qq . words)
  (string-join (map cat words)))

(define-macro (ht . pairs)
  (let ((h (gensym)))
    `(let ((,h (make-hash-table)))
       ,@(let loop ((p pairs) (result (list)))
           (cond
             ((or (null? p) (null? (cdr p))) result)
             (else (loop (cddr p) (cons `(hash-set! ,h ,(car p) ,(cadr p)) result)))))
       ,h)))

(define (htl pairs)
  (let ((h (make-hash-table)))
    (let loop ((p pairs))
      (cond
        ((or (null? p) (null? (cdr p))) h)
        (else (begin
                (hash-set! h (car p) (cadr p))
                (loop (cddr p))))))))

(define (random-pick ll)
  (let* ((ind (random (length ll)))
         (elm (list-tail ll ind)))
    (values (car elm)
            (append (list-head ll ind) (cdr elm)))))

(define (shuffle ll)
  (let loop ((p ll) (r '()))
    (if (null? p) r
      (receive (value rest) (random-pick p)
               (loop rest (cons value r))))))

(define (rotate ll i)
  (let* ((len (length ll)) (ii (modulo (abs (if (< i 0) (+ len i) i)) len)))
    (append (list-tail ll ii) (list-head ll ii))))

(define (register-here-string delim)
  (let ((delim-len (string-length delim)))
    (read-hash-extend
      #\/
      (lambda (chr port)
        (let loop ((lines '()))
          (let* ((line (read-line port))
                 (trimmed-line (string-trim line)))
            (if (and (>= (string-length trimmed-line) delim-len)
                     (string=? (substring trimmed-line 0 delim-len) delim))
              (begin
                (unget-string port (substring trimmed-line delim-len))
                (string-join (reverse lines) "\n"))
              (loop (cons line lines)))))))))

;;; MIDI

(def
  C-0 12   C0  12      C-1 24   C1  24      C-2 36   C2  36      C-3 48   C3  48      C-4 60   C4  60
  C#0 13   Db0 13      C#1 25   Db1 25      C#2 37   Db2 37      C#3 49   Db3 49      C#4 61   Db4 61
  D-0 14   D0  14      D-1 26   D1  26      D-2 38   D2  38      D-3 50   D3  50      D-4 62   D4  62
  D#0 15   Eb0 15      D#1 27   Eb1 27      D#2 39   Eb2 39      D#3 51   Eb3 51      D#4 63   Eb4 63
  E-0 16   E0  16      E-1 28   E1  28      E-2 40   E2  40      E-3 52   E3  52      E-4 64   E4  64
  F-0 17   F0  17      F-1 29   F1  29      F-2 41   F2  41      F-3 53   F3  53      F-4 65   F4  65
  F#0 18   Gb0 18      F#1 30   Gb1 30      F#2 42   Gb2 42      F#3 54   Gb3 54      F#4 66   Gb4 66
  G-0 19   G0  19      G-1 31   G1  31      G-2 43   G2  43      G-3 55   G3  55      G-4 67   G4  67
  G#0 20   Ab0 20      G#1 32   Ab1 32      G#2 44   Ab2 44      G#3 56   Ab3 56      G#4 68   Ab4 68
  A-0 21   A0  21      A-1 33   A1  33      A-2 45   A2  45      A-3 57   A3  57      A-4 69   A4  69
  A#0 22   Bb0 22      A#1 34   Bb1 34      A#2 46   Bb2 46      A#3 58   Bb3 58      A#4 70   Bb4 70
  B-0 23   B0  23      B-1 35   B1  35      B-2 47   B2  47      B-3 59   B3  59      B-4 71   B4  71
  ;
  C-5 72   C5  72      C-6 84   C6  84      C-7 96   C7  96      C-8 108  C8  108     C-9 120  C9  120
  C#5 73   Db5 73      C#6 85   Db6 85      C#7 97   Db7 97      C#8 109  Db8 109     C#9 121  Db9 121
  D-5 74   D5  74      D-6 86   D6  86      D-7 98   D7  98      D-8 110  D8  110     D-9 122  D9  122
  D#5 75   Eb5 75      D#6 87   Eb6 87      D#7 99   Eb7 99      D#8 111  Eb8 111     D#9 123  Eb9 123
  E-5 76   E5  76      E-6 88   E6  88      E-7 100  E7  100     E-8 112  E8  112     E-9 124  E9  124
  F-5 77   F5  77      F-6 89   F6  89      F-7 101  F7  101     F-8 113  F8  113     F-9 125  F9  125
  F#5 78   Gb5 78      F#6 90   Gb6 90      F#7 102  Gb7 102     F#8 114  Gb8 114     F#9 126  Gb9 126
  G-5 79   G5  79      G-6 91   G6  91      G-7 103  G7  103     G-8 115  G8  115     G-9 127  G9  127
  G#5 80   Ab5 80      G#6 92   Ab6 92      G#7 104  Ab7 104     G#8 116  Ab8 116
  A-5 81   A5  81      A-6 93   A6  93      A-7 105  A7  105     A-8 117  A8  117
  A#5 82   Bb5 82      A#6 94   Bb6 94      A#7 106  Bb7 106     A#8 118  Bb8 118
  B-5 83   B5  83      B-6 95   B6  95      B-7 107  B7  107     B-8 119  B8  119)

(define midi-frequency-table
  (vector 8.176 8.662 9.177 9.723 10.301 10.913 11.562 12.250 12.978 13.750 14.568 15.434
          16.352 17.324 18.354 19.445 20.602 21.827 23.125 24.500 25.957 27.500 29.135 30.868
          32.703 34.648 36.708 38.891 41.203 43.654 46.249 48.999 51.913 55.000 58.270 61.735
          65.406 69.296 73.416 77.782 82.407 87.307 92.499 97.999 103.826 110.000 116.541 123.471
          130.813 138.591 146.832 155.563 164.814 174.614 184.997 195.998 207.652 220.000 233.082
          246.942 261.626 277.183 293.665 311.127 329.628 349.228 369.994 391.995 415.305 440.000
          466.164 493.883 523.251 554.365 587.330 622.254 659.255 698.456 739.989 783.991 830.609
          880.000 932.328 987.767 1046.502 1108.731 1174.659 1244.508 1318.510 1396.913 1479.978
          1567.982 1661.219 1760.000 1864.655 1975.533 2093.005 2217.461 2349.318 2489.016 2637.020
          2793.826 2959.955 3135.963 3322.438 3520.000 3729.310 3951.066 4186.009 4434.922
          4698.636 4978.032 5274.041 5587.652 5919.911 6271.927 6644.875 7040.000 7458.620 7902.133
          8372.018 8869.844 9397.273 9956.063 10548.080 11175.300 11839.820 12543.850))

(define (mtof n)
  (vector-ref midi-frequency-table n))

;; parsing

(define (process port)
  (let loop ()
    (let ((c (read-char port)))
      (cond
        ((eof-object? c)
         #t)
        ((char=? c #\%)
         (display (eval (read port) (current-module)))
         (loop))
        (else
          (write-char c)
          (loop))))))

(let* ((input-file-name (list-ref (command-line) 1))
       (input-port (open-file-input-port input-file-name))
       (output-file-name (list-ref (command-line) 2)))
  (with-output-to-file output-file-name
                       (λ() (process input-port))))
