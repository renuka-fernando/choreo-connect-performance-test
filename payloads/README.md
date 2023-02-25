### Tokens

1.  Generate payloads.
    ```sh
    ./generate-payloads.sh -s "50 1024 10240 102400"
    ```
2.  Copy to servers.
    ```sh
    scp ./*.json cc-perf-test-server-1:~
    scp ./*.json cc-perf-test-server-2:~
    ```
