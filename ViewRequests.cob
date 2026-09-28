*> Epic 4
VIEW-PENDING-REQUESTS.
    PERFORM LOAD-REQUESTS
    IF WS-REQUESTS-OK = "Y"
        MOVE "--- My Pending Connection Requests ---" TO WS-MESSAGE
        PERFORM SHOW-TEXT
        MOVE "N" TO WS-PENDING-FOUND
        PERFORM VARYING WS-REQUEST-INDEX FROM 1 BY 1
            UNTIL WS-REQUEST-INDEX > WS-REQUEST-COUNT
            IF WS-REQUEST-RECIPIENT(WS-REQUEST-INDEX) = WS-USERNAME
                AND WS-REQUEST-STATE(WS-REQUEST-INDEX) = "P"
                MOVE "Y" TO WS-PENDING-FOUND
                STRING "Request from: "
                    FUNCTION TRIM(
                        WS-REQUEST-SENDER(WS-REQUEST-INDEX))
                    INTO WS-MESSAGE
                END-STRING
                PERFORM SHOW-TEXT
            END-IF
        END-PERFORM
        IF WS-PENDING-FOUND = "N"
            MOVE "You have no pending connection requests."
                TO WS-MESSAGE
            PERFORM SHOW-TEXT
        END-IF
        MOVE "Returning to main menu." TO WS-MESSAGE
        PERFORM SHOW-TEXT
    END-IF.
