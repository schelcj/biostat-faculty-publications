# Biostat Faculty Publications

## Apache configuration

### Modules to load

  * mod_headers
  * mod_proxy
  * mod_proxy_http

### Configuration file

    <Proxy *>
      Order deny,allow
      Allow from all
    </Proxy>

    ProxyRequests Off
    ProxyPreserveHost On
    ProxyPass /publications/ http://localhost:8080/ keepalive=On
    ProxyPassReverse /publications/ http://localhost:8080/
    RequestHeader set X-Forwarded-Proto "http"
