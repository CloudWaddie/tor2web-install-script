# Next Steps
## Configuration
Now open config.conf and edit it until you are happy.
> It's very self explanatory.
https://github.com/tor2web/Tor2web/wiki/Configuration-Guide for help
You _need_ to configure these:
 - nodename = [UNIQUE_IDENTIFIER]
 - Tor2web can be configured to run using multiprocessing. It's suggested to configure a number of  processes = (number of cores + 1)

    The number of request before process replacement can be configured as well; this offer the protection from memory leaks that could be present in tor2web or in external libraries.