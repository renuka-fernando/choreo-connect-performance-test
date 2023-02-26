### Tokens

1.  Generate Keys.
    ```sh
    consumer_key=''
    ```

    ```sh
    rm -rf ./target/
    ./generate-jwt-tokens.sh -t 10 -c $consumer_key
    ./generate-jwt-tokens.sh -t 50 -c $consumer_key
    ./generate-jwt-tokens.sh -t 100 -c $consumer_key
    ./generate-jwt-tokens.sh -t 200 -c $consumer_key
    ./generate-jwt-tokens.sh -t 500 -c $consumer_key
    ./generate-jwt-tokens.sh -t 1000 -c $consumer_key
    ```
2.  Copy to servers.
    ```sh
    rsync -chavzP ./target/*.csv cc-perf-test-server-1:~
    rsync -chavzP ./target/*.csv cc-perf-test-server-2:~
    ```
