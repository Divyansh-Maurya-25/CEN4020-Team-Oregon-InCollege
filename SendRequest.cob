*> Epic 4
CONNECTION-REQUEST-MENU.
    MOVE "N" TO WS-REQUEST-MENU-DONE
    PERFORM UNTIL WS-REQUEST-MENU-DONE = "Y"
        OR WS-END-INPUT = "Y"
        MOVE "1. Send Connection Request" TO WS-MESSAGE
        PERFORM SHOW-TEXT
        MOVE "2. Return to Main Menu" TO WS-MESSAGE
        PERFORM SHOW-TEXT
        MOVE "Enter your choice:" TO WS-MESSAGE
        PERFORM SHOW-TEXT
        PERFORM READ-INPUT
        IF WS-END-INPUT = "N"
            MOVE INPUT-RECORD(1:1) TO WS-REQUEST-CHOICE
            EVALUATE WS-REQUEST-CHOICE
                WHEN "1"
                    PERFORM SEND-CONNECTION-REQUEST
                    MOVE "Y" TO WS-REQUEST-MENU-DONE
                WHEN "2"
                    MOVE "Y" TO WS-REQUEST-MENU-DONE
                WHEN OTHER
                    MOVE "Please enter 1 or 2." TO WS-MESSAGE
                    PERFORM SHOW-TEXT
            END-EVALUATE
        END-IF
    END-PERFORM.

LOAD-REQUESTS.
    MOVE 0 TO WS-REQUEST-COUNT
    INITIALIZE WS-REQUESTS
    MOVE "Y" TO WS-REQUESTS-OK
    MOVE "N" TO WS-END-REQUESTS
    OPEN INPUT REQUEST-FILE
    IF WS-REQUEST-STATUS = "00" OR "05"
        PERFORM UNTIL WS-END-REQUESTS = "Y"
            READ REQUEST-FILE
            EVALUATE WS-REQUEST-STATUS
                WHEN "10"
                    MOVE "Y" TO WS-END-REQUESTS
                WHEN "00"
                    IF REQUEST-SENDER = SPACES
                        OR REQUEST-RECIPIENT = SPACES
                        OR (REQUEST-STATE NOT = "P" AND "C")
                        OR WS-REQUEST-COUNT >= 20
                        MOVE "N" TO WS-REQUESTS-OK
                        MOVE "Y" TO WS-END-REQUESTS
                    ELSE
                        ADD 1 TO WS-REQUEST-COUNT
                        MOVE REQUEST-RECORD
                            TO WS-REQUEST(WS-REQUEST-COUNT)
                    END-IF
                WHEN OTHER
                    MOVE "N" TO WS-REQUESTS-OK
                    MOVE "Y" TO WS-END-REQUESTS
            END-EVALUATE
        END-PERFORM
        CLOSE REQUEST-FILE
        IF WS-REQUEST-STATUS NOT = "00"
            MOVE "N" TO WS-REQUESTS-OK
        END-IF
    ELSE
        MOVE "N" TO WS-REQUESTS-OK
    END-IF
    IF WS-REQUESTS-OK = "N"
        MOVE "Could not load connection requests. Check requests.dat."
            TO WS-MESSAGE
        PERFORM SHOW-TEXT
    END-IF.

SEND-CONNECTION-REQUEST.
    MOVE "N" TO WS-TARGET-FOUND
    PERFORM VARYING WS-ACCOUNT-INDEX FROM 1 BY 1
        UNTIL WS-ACCOUNT-INDEX > WS-ACCOUNT-COUNT
        IF WS-TARGET-USERNAME = WS-SAVED-USERNAME(WS-ACCOUNT-INDEX)
            MOVE "Y" TO WS-TARGET-FOUND
        END-IF
    END-PERFORM

    EVALUATE TRUE
        WHEN WS-TARGET-FOUND = "N"
            MOVE "That user could not be found." TO WS-MESSAGE
            PERFORM SHOW-TEXT
        WHEN WS-TARGET-USERNAME = WS-USERNAME
            MOVE "You cannot send a connection request to yourself."
                TO WS-MESSAGE
            PERFORM SHOW-TEXT
        WHEN OTHER
            PERFORM LOAD-REQUESTS
            IF WS-REQUESTS-OK = "Y"
                PERFORM CHECK-CONNECTION-REQUEST
                EVALUATE TRUE
                    WHEN WS-ALREADY-CONNECTED = "Y"
                        MOVE "You are already connected with this user."
                            TO WS-MESSAGE
                        PERFORM SHOW-TEXT
                    WHEN WS-REVERSE-REQUEST = "Y"
                        MOVE "This user has already sent you a connection request."
                            TO WS-MESSAGE
                        PERFORM SHOW-TEXT
                    WHEN WS-OUTGOING-REQUEST = "Y"
                        MOVE "You have already sent this user a connection request."
                            TO WS-MESSAGE
                        PERFORM SHOW-TEXT
                    WHEN WS-REQUEST-COUNT >= 20
                        MOVE "The connection request file is full."
                            TO WS-MESSAGE
                        PERFORM SHOW-TEXT
                    WHEN OTHER
                        PERFORM SAVE-CONNECTION-REQUEST
                END-EVALUATE
            END-IF
    END-EVALUATE.

CHECK-CONNECTION-REQUEST.
    MOVE "N" TO WS-ALREADY-CONNECTED
        WS-OUTGOING-REQUEST WS-REVERSE-REQUEST
    PERFORM VARYING WS-REQUEST-INDEX FROM 1 BY 1
        UNTIL WS-REQUEST-INDEX > WS-REQUEST-COUNT
        IF WS-REQUEST-SENDER(WS-REQUEST-INDEX) = WS-USERNAME
            AND WS-REQUEST-RECIPIENT(WS-REQUEST-INDEX)
                = WS-TARGET-USERNAME
            IF WS-REQUEST-STATE(WS-REQUEST-INDEX) = "C"
                MOVE "Y" TO WS-ALREADY-CONNECTED
            ELSE
                MOVE "Y" TO WS-OUTGOING-REQUEST
            END-IF
        END-IF
        IF WS-REQUEST-SENDER(WS-REQUEST-INDEX) = WS-TARGET-USERNAME
            AND WS-REQUEST-RECIPIENT(WS-REQUEST-INDEX) = WS-USERNAME
            IF WS-REQUEST-STATE(WS-REQUEST-INDEX) = "C"
                MOVE "Y" TO WS-ALREADY-CONNECTED
            ELSE
                MOVE "Y" TO WS-REVERSE-REQUEST
            END-IF
        END-IF
    END-PERFORM.

SAVE-CONNECTION-REQUEST.
    OPEN EXTEND REQUEST-FILE
    IF WS-REQUEST-STATUS = "00" OR "05"
        MOVE WS-USERNAME TO REQUEST-SENDER
        MOVE WS-TARGET-USERNAME TO REQUEST-RECIPIENT
        MOVE "P" TO REQUEST-STATE
        WRITE REQUEST-RECORD
        IF WS-REQUEST-STATUS NOT = "00"
            MOVE "N" TO WS-REQUESTS-OK
        END-IF
        CLOSE REQUEST-FILE
        IF WS-REQUEST-STATUS NOT = "00"
            MOVE "N" TO WS-REQUESTS-OK
        END-IF
    ELSE
        MOVE "N" TO WS-REQUESTS-OK
    END-IF
    IF WS-REQUESTS-OK = "Y"
        MOVE "Connection request sent successfully." TO WS-MESSAGE
    ELSE
        MOVE "Could not save the connection request." TO WS-MESSAGE
    END-IF
    PERFORM SHOW-TEXT.
