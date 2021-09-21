# Localhost HTTPS (Trusted SSL Certificate)

## Why

All the detailed instructions I had found were correct for the time they were written. Not anymore.

### Option (Manual)

```javascript
sendCommand(SecurityInterstitialCommandId.CMD_PROCEED)
```

## Installation

### 1. Configuration

You can adjust the `[dn]` part of the `openssl-custom.cnf` file to whatever you prefer.

```
[dn]
C = <COUNTRY>
ST = <STATE>
L = <LOCALITY / CITY>
O = <ORGANIZATION>
OU = <ORGANIZATION_UNIT>
emailAddress = <EMAIL_ADDRESS>
CN = <HOSTNAME / IP_ADDRESS>
``` 

### 2. Generate Keys

This repository contains a script that will generate a trusted SSL certificate which can be used for local software development.

```
git clone https://github.com/bob-fornal/localhost-https.git
cd localhost-https
bash generate.sh
```

### 3. Trust the root SSL Certificate

* Open Keychain Access on a Mac
* Go to the Certificates category in the System keychain.
* Once there, import the `rootCA.pem` using File > Import Items (or drag and drop).
* Double click the imported certificate and change the “When using this certificate:” dropdown to **Always Trust** in the Trust section.

### 4. Generate Domain SSL Certificate

The root SSL certificate can now be used to issue a certificate specifically for your local development environment located at `localhost`.

A certificate signing request is issued via the root SSL certificate created earlier to create a domain certificate for `localhost`. The output is a certificate file called `server.crt`.

## Usage

### Node

Move `server.key` and `server.crt` to an accessible location on the server and include them when starting it. In an Express app running on Node.js, the code would look something like this:

```javascript
var path = require('path');
var fs = require('fs');
var express = require('express');
var https = require('https');

var certOptions = {
  key: fs.readFileSync(path.resolve('build/cert/server.key')),
  cert: fs.readFileSync(path.resolve('build/cert/server.crt'))
};

var app = express();

var server = https.createServer(certOptions, app).listen(443);
```

### Angular

Move `server.key` and `server.crt` to an accessible location in the project. Then, update the `angular.json` file for serving the code.

```json
"serve": {
  ...
  "options": {
    "sslKey": "./certificates/server.key",
    "sslCert": "./certificates/server.crt",
    "ssl": true
  }
}
```
