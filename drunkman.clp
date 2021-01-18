        (deffunction check (?x ?y)
            (while (or
            (> ?x 9) (< ?x 2)
            (> ?y 9) (< ?y 2)) do
            (printout t crlf "Drunkman must not be on the edges, please try another coordinates" crlf )
            (printout t crlf "Place your drunkman at x: " )
            (bind ?x (read))
            (printout t crlf "Place your drunkman at y: " )
            (bind ?y (read)))
            (assert (drunkman_at ?x ?y))  ;Τοποθέτηση drunkman
        )
	
	(deffact static-facts  ;Αρχικοποίηση πίστας
        (obstacle_at 1 1)   ;Ορίζουμε τα εμπόδια
        (obstacle_at 1 2)
        (obstacle_at 1 3)
        (obstacle_at 1 4)
        (obstacle_at 1 5)
        (obstacle_at 1 6)
        (obstacle_at 1 7)
        (obstacle_at 1 8)
        (obstacle_at 1 9)
        (obstacle_at 1 10)
        (obstacle_at 2 1)
        (obstacle_at 2 2)
        (obstacle_at 2 9)
        (obstacle_at 2 10)
        (obstacle_at 3 1)
        (obstacle_at 3 5)
        (obstacle_at 3 6)
        (obstacle_at 3 10)
        (obstacle_at 4 1)
        (obstacle_at 4 5)
        (obstacle_at 4 6)
        (obstacle_at 4 10)
        (obstacle_at 7 1)
        (obstacle_at 7 5)
        (obstacle_at 7 6)
        (obstacle_at 7 10)
        (obstacle_at 8 1)
        (obstacle_at 8 5)
        (obstacle_at 8 6)
        (obstacle_at 8 10)
        (obstacle_at 9 1)
        (obstacle_at 9 2)
        (obstacle_at 9 9)
        (obstacle_at 9 10)
        (obstacle_at 10 1)
        (obstacle_at 10 2)
        (obstacle_at 10 3)
        (obstacle_at 10 4)
        (obstacle_at 10 5)
        (obstacle_at 10 6)
        (obstacle_at 10 7)
        (obstacle_at 10 8)
        (obstacle_at 10 9)
        (obstacle_at 10 10)

        (good_fruit_at 2 4) ;Τοποθετούμε τα καλά φρούτα στην πίστα
        (good_fruit_at 2 7)
        (good_fruit_at 3 9)
        (good_fruit_at 4 3)
        (good_fruit_at 4 8)
        (good_fruit_at 5 1)
        (good_fruit_at 8 4)
        (good_fruit_at 8 9)
        (good_fruit_at 9 3)
        (good_fruit_at 9 5)
        (good_fruit_at 9 7)

        (bad_fruit_at 2 3)  ;Τοποθετούμε τα κακά φρούτα στην πίστα
        (bad_fruit_at 4 9)
        (bad_fruit_at 5 6)
        (bad_fruit_at 5 9)
        (bad_fruit_at 7 2)
        (bad_fruit_at 7 3)
        (bad_fruit_at 7 8)
        
        (choice -1 0)       ;Μοντελοποίηση κίνησης 'choice x y'
        (choice 1 0)        ;Απλά θα προσθέτουμε το εκάστοτε x y 
        (choice 0 -1)       ;στην υπάρχουσα θέση. Με αυτό τον τρόπο
        (choice 0 1)        ;ο drunkman θα κινείται στον χώρο

        (moves_left 100)    ;Οι αρχικές κινήσεις του drunkman 
    )

    (defrule begin
        (initial-fact)      ;Αρχικός κανόνας
    =>
        
        (printout t crlf "Place your drunkman at x: " )
		(bind ?x (read))
		(printout t crlf "Place your drunkman at y: " )
        (bind ?y (read))
        (check ?x ?y)

        ;(assert (drunkman_at ?x ?y))  ;Τοποθέτηση drunkman
        (assert (direction 1 0))    ;Αρχική κατεύθυνση προς τα δεξιά
    )

    (defrule goal_found                 ;Κανόνας που ελέγχει την εύρεση στόχου
        (declare (salience 3))          ;Μεγάλη προτεραιότητα
        (not (good_fruit_at ?x ?y))     ;Αν δεν υπάρχει κανένα καλό φρούτο
    =>
        (printout t  crlf crlf "YOU WON!" crlf crlf)
        (halt)  ;Κέρδισες!
    )

    (defrule lost               ;Μπορεί και να χάσεις όμως
        (declare (salience 3))  
        (moves_left 0)          ;Αν ξεμείνεις από κινήσεις
    =>
        (printout t  crlf crlf "YOU LOST!" crlf crlf)
        (halt)
    )

    (defrule detect_good_fruit      ;Ώρα για φαΐ
        (declare (salience 2))
        (drunkman_at ?fx ?fy)          ;Αν στο παρόν τετράγωνο
        ?f <- (good_fruit_at ?fx ?fy)  ;Υπάρχει καλό φρούτο
        ?m1 <- (moves_left ?m)         ;Κρατάμε τον αριθμό υπολειπόμενων κινήσεων
    =>
        (printout t "good fruit is found at position " ?fx "-" ?fy " !" crlf)
        (retract ?f)    ;Αφαιρούμε το φρούτο
        (retract ?m1)   ;Αφαιρούμε το γεγονός υπολειπόμενων κινήσεων
        (assert (moves_left (+ ?m 50))) ;Και το προσθέτουμε ξανά με +50 κινήσεις
        
    )

    (defrule detect_bad_fruit   ;Αν το φρούτο όμως είναι χαλασμένο;
        (declare (salience 2))
        (drunkman_at ?fx ?fy)
        ?f <- (bad_fruit_at ?fx ?fy)    
        
    =>
        (printout t "bad fruit is found at position " ?fx "-" ?fy " !" crlf)
        (printout t "new obstacle in " ?fx "-" ?fy " !" crlf)
        (retract ?f)                    ;Τρώμε το φρούτο και στην θέση του
        (assert (obstacle_at ?fx ?fy))  ;Τοποθετείται ένα νέο εμπόδιο
        
    )

    (defrule move   ;Κανόνας κίνησης. Με κάθε κίνηση, αλλάζουμε και την κατεύθυνση.
    ;Αυτο θα μας βοηθήσει να έχουμε μια τυχαιότητα στην κίνηση
    ;Η τυχαιότητα το κάνει πιο διασκεδαστικό!
        ?f <- (drunkman_at ?fx ?fy) ;Κρατάμε την θέση του drunkman
        ?d <- (direction ?dx ?dy)   ;Κρατάμε την κατεύθυνση του
        (choice ?ndx ?ndy)          ;Διαλέγουμε μια νέα κατεύθυνση
        (or 
           (test (<> ?ndx ?dx))     ;Που πρέπει να είναι διαφορετική της τέουσας
           (test (<> ?ndy ?dy))     ;είτε κατα x είτε κατα y
        )
        ?m1 <- (moves_left ?m)      ;Κρατάμε και τις υπολοιπόμενες κινήσεις
    =>
        (retract ?f)    ;Αφαιρούμε το drunkman από το παρόν τετράγωνο
        (retract ?d)    ;Αλλάζουμε και την κατεύθυνση του
        (assert (direction ?ndx ?ndy))  ;Προσθέτουμε την νέα κατεύθυνση
        (assert (drunkman_at (+ ?dx ?fx) (+ ?dy ?fy)))  ;Τοποθετούμε τον drunkman στο νέο τετράγωνο
        (retract ?m1)   
        (assert (moves_left (- ?m 1)))  ;Αφαιρούμε μία κίνηση από το γεγονός εναπομείναντων κινήσεων
        (printout t "drunkman at " (+ ?dx ?fx) "," (+ ?dy ?fy) " " crlf)    
        (printout t "moves left =" (- ?m 1) " " crlf)  ;Ανακοινώνουμε τα μαντάτα
    )

    (defrule avoid_obstacle ;Αν προς την κατεύθυνση που κινούμαστε υπάρχει εμπόδιο;
        (declare (salience 1))  ;Μεγαλύτερη προτεραιότητα από την κίνηση
        
        (drunkman_at ?fx ?fy)   
        ?f <- (direction ?dx ?dy)
        (choice ?ndx ?ndy)
        (or 
           (test (<> ?ndx ?dx))
           (test (<> ?ndy ?dy))
        )
        (or
            (obstacle_at =(+ ?fx ?dx) =(+ ?fy ?dy)) ;Αν στο επόμενο τετράγωνο έχει εμπόδιο
            (test (< (+ ?fx ?dx) 1))    ;Ή αν πάμε να βγούμε εκτός ορίων πίστας
            (test (< (+ ?fy ?dy) 1))    ;προς οποιαδήποτε κατεύθυνση
            (test (> (+ ?fx ?dx) 10))
            (test (> (+ ?fy ?dy) 10))
        )  
    =>     
        (retract ?f)
        (assert (direction ?ndx ?ndy))  ;Ορίζουμε νέα κατεύθυνση
        (printout t "new direction " ?ndx "," ?ndy " !" crlf)
    )
