## IBM Watson IoT with node.js examples

Made for [netPI](https://www.netiot.com/netpi/), the Raspberry Pi 3B Architecture based industrial suited Open Edge Connectivity Ecosystem

### Debian with IBM Watson IoT node.js based client library, node.js samples, SSH server and user root

The image provided hereunder deploys a container with installed node.js client library for IBM Watson IoT and ready-to-use sample applications connecting to your personal IBM Watson IoT Platform after a short setup.

Base of this image builds [debian](https://www.balena.io/docs/reference/base-images/base-images/) with enabled [SSH](https://en.wikipedia.org/wiki/Secure_Shell), created user 'root' and preinstalled node.js library from [IBM Watson IoT repo](https://github.com/ibm-watson-iot/iot-nodejs) with examples.

Before using the examples you have to sign up with [IBM Cloud](https://console.bluemix.net/) and create an account. At the time of image preparation a lite(free) account includes up to 500 registered devices, and a maximum of 200 MB of each data metric per month for free.

#### Container prerequisites

##### Port mapping

For remote login to the container across SSH the container's SSH port `22` needs to be mapped to any free netPI host port.

#### Getting started

STEP 1. Open netPI's landing page under `https://<netpi's ip address>`.

STEP 2. Click the Docker tile to open the [Portainer.io](http://portainer.io/) Docker management user interface.

STEP 3. Enter the following parameters under **Containers > Add Container**

* **Image**: `hilschernetpi/netpi-ibm-watsoniot-nodejs`

* **Port mapping**: `Host "22" (any unused one) -> Container "22"` 

* **Restart policy"** : `always`

STEP 4. Press the button **Actions > Start/Deploy container**

Pulling the image may take a while (5-10mins). Sometimes it takes so long that a time out is indicated. In this case repeat the **Actions > Start/Deploy container** action.

#### Accessing

The container starts the SSH server automatically. Open a terminal connection to it with an SSH client such as [putty](http://www.putty.org/) using netPI's IP address at your mapped port.

Use the credentials `root` as user and `root` as password when asked and you are logged in as root user `root`.

##### IBM Cloud 

STEP 1: Login to IBM Cloud

STEP 2: Start creating an `App` under [Dashboard](https://console.bluemix.net/dashboard/apps/) clicking `Watson Starter Kit` and then `Create App`. 

STEP 3: The type of platform is neglectable. Select `node.js` is fine. Change the App name to something like `MyRaspberry` and click `Create`.

STEP 4: Click `Add Resource` then `Data(..)` and `Next`. As resource highlight `Internet of Things` and click a final `Create`.

STEP 5: After creation you receive back credentials of your just created IBM Watson IoT Platform as reference. You will be getting a JSON string like this:

```
[
  {
    "name": "myraspberry-iotplatform-2533345694461",
    "id": "756df960-4d85-3862-9d9e-706567b15bb8",
    "credentials": [
      {
        "iotCredentialsIdentifier": "d2g6i39kl6r5",
        "mqtt_host": "ga5u4s.messaging.internetofthings.ibmcloud.com",
        "mqtt_u_port": 1883,
        "mqtt_s_port": 8883,
        "http_host": "ga5u4s.internetofthings.ibmcloud.com",
        "org": "ga5u4s",
        "apiKey": "h-ga5u4s-zhtb5vchae",
        "apiToken": "uF66U1wGGj?*+12!Rv"
      }
    ]
  }
]
```

STEP 6: Click `Dashboard` in the menu pane to the left. See the just created Watson IoT Platform as `myraspberry-iotplatform-2533345694461` listed. Click it and then `Launch`.

STEP 7: You will be forwarded to `https://[org_id].internetofthings.ibmcloud.com/dashboard/#/` with [org_id] replaced by the `org` value of your credentials ("ga5u4s" as stated in the example above).

STEP 8: In the overview dashboard left, from the menu pane, click `Devices` and then click `Add Device`. To match with the example below use name "drone" as `Device Name` and e.g. "12345678" as `Device ID`. It is needed to get it listed by the example later. The authentication token is up to you and also filling out the additional `Meta Data` is optional.

STEP 9: From  the menu pane click `Devices` and then `Device Types` and then `Add Device Type`. Highlight `Device` and enter "raspi" as device type name and click `Next`.

Now you Watson IoT Platform is prepared with a device "drone" and a device type "raspi" needed for the example. 

A lite account has a limited access time until IBM brings an advertisement page to the front. Start a new browser session in this case to recover.

##### node.js samples

Find the node.js client library API call reference documented [here](https://github.com/ibm-watson-iot/iot-nodejs/blob/master/README.md). All examples are based on this API.

STEP 1: Transfer your credentials to the `ApplicationSample.js` file to get it working. In our example change

```
var appClientConfig = {
  org: 'xxxxx',
  id: 'myapp',
  "domain": "internetofthings.ibmcloud.com",
  "auth-key": 'a-xxxxxxx-zenkqyfiea',
  "auth-token": 'xxxxxxxxxx'
};
```

to 

```
var appClientConfig = {
  org: 'ga5u4s',
  id: '756df960-4d85-3862-9d9e-706567b15bb8',
  "domain": "internetofthings.ibmcloud.com",
  "auth-key": 'h-ga5u4s-zhtb5vchae',
  "auth-token": 'uF66U1wGGj?*+12!Rv'
};
```

(Your will be obviously different).

STEP 2: Save your modifications and execute the sample with `node ApplicationSample.js`.

STEP 3: Watch the console output indicating the successful login to your Watson IoT Platform, listing devices of type "drone", registering a new device type "newType1" and device "new01012220" of type "raspi" (and auth-token "token12345", not visible).

STEP 4: To publish data to the just created device modify the file `device.json` to match the credentials both the platform and the device like

```
{
  "org": "wp5u4s",
  "domain": "internetofthings.ibmcloud.com",
  "type": "raspi",
  "id": "new01012220",
  "auth-method": "token",
  "auth-token": "token12345",
  "use-client-certs": false,
  "server-ca": "path to custom server certificate",
  "client-ca": "path to device-client ca certificate",
  "client-cert": "path to device-client certificate",
  "client-key": "path to device-client key",
  "client-key-passphrase": "client-key-password"
}
```

STEP 5: Call `node deviceSampleWithHTTPs.js` and watch the received value "23" with the event type "myevt" under `Recent Events` on the Watson Platform. 

#### Automated build

The project complies with the scripting based [Dockerfile](https://docs.docker.com/engine/reference/builder/) method to build the image output file. Using this method is a precondition for an [automated](https://docs.docker.com/docker-hub/builds/) web based build process on DockerHub platform.

DockerHub web platform is x86 CPU based, but an ARM CPU coded output file is needed for Raspberry systems. This is why the Dockerfile includes the [balena](https://balena.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/) steps.

#### License

View the license information for the software in the project. As with all Docker images, these likely also contain other software which may be under other licenses (such as Bash, etc from the base distribution, along with any direct or indirect dependencies of the primary software being contained).
As for any pre-built image usage, it is the image user's responsibility to ensure that any use of this image complies with any relevant licenses for all software contained within.

[![N|Solid](http://www.hilscher.com/fileadmin/templates/doctima_2013/resources/Images/logo_hilscher.png)](http://www.hilscher.com)  Hilscher Gesellschaft fuer Systemautomation mbH  www.hilscher.com
