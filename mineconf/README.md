# cpuminer-multi
Dockerized Crypto Miner

-----

- Select the crypto miner implementation:
    ```
    MINER={cpuminer-multi | cpuminer-opt | cpuminer-rkz | cpuminer-opt-sugarchain | cpuminer-opt-cpupower | cpuminer-opt-neoscrypt }
    ```
- Set the architecture of the host:
    ```
    ARCH="`gcc -march=native -Q --help=target | awk '$1 == "-march=" {print $2}'`"
    ```
- (Optional) select another configuration; otherwise leave this variable blank or unset:
    ```
    CNF=btc
    ```
- (Optional) customize the configuration; otherwise, leave this variable blank or unset:
    ```
    #VOL='-v ./secrets/:/conf.d/:ro'
    VOL="--mount type=bind,source=$(pwd)/secrets,target=/conf.d,readonly"
    ```
- Decide whether to run always or run once:
    ```
    DCMD='docker service create' || # run always
    DCMD='docker run'               # run once
    ```
- Run the crypto miner that has been compiled for your host architecture:
    ```
    $DCMD -d --name "$MINER" --read-only --restart always --rm $VOL "innovanon/$MINER:$ARCH" $CNF
    ```

### Innovations Anonymous
Free Code for a Free World!

-----
Thank you for supporting our ministry :)

