# Overview

This is a collection of supporting material from the **Make you Microservices sing!** talk at [Oracle Code Sydney](https://developer.oracle.com/code/sydney) on the 18th of July, 2017.

## The presentation

The presentation link will be added here the day after the session.

## The code

* [MedRec Monolithic Application](https://github.com/craigbarrau/medrec-monolith): WebLogic application on Docker
* [Physicians Microservice](https://github.com/craigbarrau/medrec-physicians): Simple NodeJS API on Docker
* [Patients Microservice](https://github.com/craigbarrau/medrec-patients): Simple Java Spring API example with Liquibase on Docker

## Prerequisites for running the examples

* At a minimum, you will require `git`, `docker` and `docker-compose` to run the examples
* Additionally, you may wish to 
  * install `swagger` to view the API documentation, use the API editor or create codeless mocks for new API operations
  * install `wercker` to test out the CI/CD job locally before pushing any changes to Wercker

## Run the MedRec Monolithic example

1. Follow the first two steps [here](http://blog.rubiconred.com/a-first-look-at-the-oracle-container-registry/) to ensure you have connected to Oracle Container Registry.
2. Pull down the Oracle WebLogic Domain image with the command 
```
docker pull container-registry.oracle.com/middleware/weblogic:12.2.1.1
```
3. Checkout the medrec monolithic codebase and navigate to it
```
git clone https://github.com/craigbarrau/medrec-monolith
cd medrec-monolith
```
4. Install WebLogic natively and select the option to include the samples. We need to do this to get access to the MedRec source and distribution files. Sorry about the extra pain but this is the only way to get the sample source code and/or distribution ear files. They are not shared on a public repository by Oracle other than via download of WebLogic from [here](http://www.oracle.com/technetwork/middleware/fusion-middleware/downloads/index.html). You will need an Oracle account to download.
5. After installation, copy `medrec.ear` and `physician.ear` from the local WebLogic installation (refered to as `ORACLE_HOME`) to the `medrec-monolith` directory which we previously cloned from `git`
```
cp $ORACLE_HOME/wlserver/samples/server/medrec/dist/standalone/medrec.ear .
cp $ORACLE_HOME/wlserver/samples/server/medrec/dist/standalone/physician.ear .
```
6. Copy `medrec-data-import.jar` and `medrec-domain.jar` to the seed directory. We will need to use these when we seed the data for the MedRec application
```
mkdir -p seed
cp $ORACLE_HOME/wlserver/samples/server/medrec/dist/modules/medrec-data-import.jar seed/.
cp $ORACLE_HOME/wlserver/samples/server/medrec/dist/modules/medrec-domain.jar seed/.
```
7. Navigate ot the `medrec-monolithic` directory and run 
```
docker build -t medrec-monolith .
```
8. Start the container with
```
docker run -d -p 7001:7001 --name medrec medrec-monolith 
```
9. Wait for the instance to startup at `http://localhost:7001/medrec`. We can tail the logs with `docker logs -f medrec`. We know it is running when we see a log message like this:
```
<Jul 19, 2017, 12:23:01,939 AM UTC> <Notice> <WebLogicServer> <BEA-000360> <The server started in RUNNING mode.> 
<Jul 19, 2017, 12:23:01,965 AM UTC> <Notice> <WebLogicServer> <BEA-000365> <Server state changed to RUNNING.>
```
9. Seed the data for our monolithic MedRec application by running the following
```
docker exec -ti medrec /bin/bash -c "java -classpath \$ORACLE_HOME/seed/medrec-data-import.jar:\$ORACLE_HOME/seed/medrec-domain.jar:\$ORACLE_HOME/wlserver/common/derby/lib/derbyclient.jar:\$ORACLE_HOME/wlserver/server/lib/weblogic.jar com.oracle.medrec.util.DataImporter"
If it is successful we should see the message `All the data has been imported successfully!`
```
10. We can access our application at `http://localhost:7001/medrec`

## Run the MedRec Physicians NodeJS Microservice

1. Checkout the Physicians project
```
git clone https://github.com/craigbarrau/medrec-physicians
```
2. Navigate to the project and start it using `docker-compose`
```
cd medrec-physicians && docker-compose up –d
```
3. Test access to the API using
```
curl http://localhost:10010/physicians
```
4. If you want to test the Swagger definition, try this:
```
swagger project edit
```
5. If you want to build using `wercker` try this:
```
wercker dev
```

## Run the MedRec Patients Java Spring + Liquibase Microservice

1. Checkout the Physicians project
```
git clone https://github.com/craigbarrau/medrec-patients
```
2. Navigate to the project and start it using `docker-compose`
```
cd medrec-physicians && docker-compose up –d
```
3. Test access to the API using
```
curl http://localhost:10011/medrec/patients
```

## Supporting articles

* [Topdown Polyglot Microservices with OpenAPI](http://blog.rubiconred.com/topdown-polyglot-microservices-with-openapi/)
* [Tips and tricks for configuring WebLogic Resources on Docker boot](http://blog.rubiconred.com/tips-and-tricks-for-configuring-weblogic-resources-on-docker-boot)

## Related content

* [Anki-MedRec Lab Exercises](https://barackd222.github.io/)
* [Complete MedRec API Example](https://github.com/barackd222/ankimedrec-apis)

## Other Resources

* **Want help getting started with Oracle Cloud?** [Cloud KickStart Datasheet](https://www.rubiconred.com/resource/datasheet-cloud-kickstart/)

* **Case Study**: [Oracle Process Cloud Service (PCS) at Rubicon Red](https://www.rubiconred.com/resource/cs-rubicon-red-oracle-pcs/)

* **Blog:** [Uncovering Booking Fraud with PCS and Decision Model Notation (DMN)](http://blog.rubiconred.com/complex-decision-making-using-dmn-in-oracle-process-cloud-service/)

* **Blog:** [Streamline your PCS models with DMN](http://blog.rubiconred.com/working-with-decision-model-and-notation-in-oracle-process-cloud-service/)

* **Blog:** [Patient Health Monitoring with Internet of Things (IOT) and PCS](http://blog.rubiconred.com/iot-health-monitoring/)

* **Blog:** [Integration Cloud Service (ICS) and Twilio](http://blog.rubiconred.com/oracle-ics-and-twilio-publish-subscribe-integration-pattern/)


## Wishlist

* Add documentation on how to edit the projects using Swagger
* Connect the Physicians NodeJS project to MongoDB
* Flesh out the Patients service implementation to the point of completeness. At present, it supports `GET` only
* Investigate use of SpringBoot for Patients services
* Add `manifest.json` so the examples can also be deployed to Application Container Cloud Service
* Generate the Swagger definition for the Patients codebase to demonstrate the Bottom up approach
* Create Oracle Developer Cloud Service example build process for one of the microservices
* Establish rolling deployment process on Kubernetes with Oracle Compute or Oracle Container Cloud Service
* Link to the corresponding repositories on [Apiary.io](https://apiary.io) and [Swagger Hub](https://app.swaggerhub.com/)

