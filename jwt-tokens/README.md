### Tokens

1.  Generate Keys.
    ```sh
    ./generate-jwt-tokens.sh -t 1000 -c <consumer_key>
    ```
2.  Copy to servers.
    ```sh
    scp ./jwt-tokens.csv cc-perf-test-server-1:~
    scp ./jwt-tokens.csv cc-perf-test-server-2:~
    ```
