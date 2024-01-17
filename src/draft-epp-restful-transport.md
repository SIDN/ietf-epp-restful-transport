%%%
title = "Extensible Provisioning Protocol (EPP) RESTful Transport"
abbrev = "RESTful Transport for EPP"
ipr = "trust200902"
area = "Internet"
workgroup = "Network Working Group"
submissiontype = "IETF"
keyword = [""]
TocDepth = 4

[seriesInfo]
name = "Internet-Draft"
value = "draft-wullink-restful-epp-01"
stream = "IETF"
status = "standard"

[[author]]
initials="M."
surname="Wullink"
fullname="Maarten Wullink"
abbrev = ""
organization = "SIDN Labs"
  [author.address]
  email = "maarten.wullink@sidn.nl"
  uri = "https://sidn.nl/"

[[author]]
initials="M."
surname="Davids"
fullname="Marco Davids"
abbrev = ""
organization = "SIDN Labs"
  [author.address]
  email = "marco.davids@sidn.nl"
  uri = "https://sidn.nl/"
%%%

.# Abstract

This document describes RESTful EPP (REPP), a data format agnostic, REST based Application Programming Interface (API) for the Extensible Provisioning Protocol [@!RFC5730]. REPP enables the development of a stateless and scaleable EPP service.

This document includes a mapping of [@!RFC5730] [@!XML] EPP commands to a RESTful HTTP based interface. Existing semantics as defined in [@!RFC5731], [@!RFC5732] and [@!RFC5733] are retained and reused in RESTful EPP. 

{mainmatter}

# Introduction

This document describes an Application Programming Interface (API) for the Extensible Provisioning Protocol (EPP) protocol described in [@!RFC5730]. The API leverages the HTTP protocol [@!RFC2616] and the principles of [@!REST]. Conforming to the REST constraints is generally referred to as being "RESTful". Hence the API is dubbed: "'RESTful EPP" or "REPP" for short.

REPP includes a mapping of [@!RFC5730] EPP commands to REST resources based on Uniform Resource Locators (URLs) defined in [@!RFC1738]. REPP uses a stateless architecture. It aims to provide a solution that is more suitable for complex, high availability environments.

[@!RFC5730, Section 2.1] of [@!RFC5730] describes how EPP can be layered over multiple transport protocols. Currently, EPP transport over TCP [@!RFC5734] is the only widely deployed transport mapping for EPP. [@!RFC5730, Section 2.1] furthermore requires that newly defined transport mappings preserve the stateful nature of EPP. This document updates this requirement to also allow stateless for EPP transport.

The stateless nature of REPP requires that no client or application state is maintained on the server. Each client request to the server must contain all the information necessary for the server to process the request.

REPP is data format agnostic, the client uses agent-driven content negotiation. Allowing the client to select from a set of representation media types supported by the server, such as XML, JSON [@!RFC8259] or [@!YAML].

# Terminology

In this document the following terminology is used.

REST - Representational State Transfer ([@!REST]). An architectural style.

RESTful - A RESTful web service is a web service or API implemented using HTTP and the principles of [@!REST].

EPP RFCs - This is a reference to the EPP version 1.0 specifications [@!RFC5730], [@!RFC5731], [@!RFC5732] and [@!RFC5733].

Stateful EPP - The definition according to [@!RFC5730, section 2].

RESTful EPP or REPP - The RESTful transport for EPP described in this document.

URL - A Uniform Resource Locator as defined in [@!RFC3986].

Resource - An object having a type, data and possible relationship to other resources, identified by a URL.

Command Mapping - A mapping of [@!RFC5730] EPP commands to RESTful EPP URL resources.

REPP client - An HTTP user agent performing an REPP request 

REPP server - An HTTP server resposible for processing requests and returning results in any supported media type.


# Conventions Used in This Document

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT","SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [@!RFC2119].

XML is case sensitive. Unless stated otherwise, XML specifications and examples provided in this document MUST be interpreted in the character case presented to develop a conforming implementation.

The examples in this document assume that request and response messages are properly formatted XML documents.  

In examples, lines starting with "C:" represent data sent by a REPP client and lines starting with "S:" represent data returned by a REPP server. Indentation and white space in examples are provided only to illustrate element relationships and are not REQUIRED features of the protocol.

All example requests assume a REPP server using HTTP version 2 is listening on the standard HTTPS port on host reppp.example.nl. An authorization token has been provided by an out of band process and MUST be used by the client to authenticate each request.

# Design Considerations

RESTful transport for EPP (REPP) is designed to improve the ease of design, development, deployment and management
of an EPP service, while maintaining compatibility with the existing EPP RFCs.
This section lists the main design criteria.

- Ease of use, provide a clear, clean, easy to use and self-explanatory interface that can easily be integrated into existing software systems. On the basis of these principles a [@!REST] architectural style was chosen, where a client  interacts with a REPP server via HTTP.

- Scalability, HTTP allows the use of well know mechanisms for creating scalable systems, such as 
  load balancing. Load balancing at the level of request messages is more efficient compared to load balancing based on TCP sessions. When using EPP over TCP, the TCP session can be used to transmit multiple request messages and these are then all processed by a single EPP server and not load balanced across a pool of available servers. During normal registry operations, the bulk of EPP requests canb be expected to be of the informational type, load balancing and possibly seperating these to dedicated compute resources may also improve registry services and provide better performance for the transform request types.   

- Stateless, [@!RFC5730] REQUIRES a stateful session between a client and server. A REPP server MUST be stateless and MUST NOT keep client session or any other application state. Each client request needs to provide all of the information necessary for the server to successfully process the request.

- Security, allow for the use of authentication and authorization solutions available 
  for HTTP based applications. HTTP provides an Authorization header [@!RFC2616, section 14.8].

- Content negotiation, A server may choose to include support for multiple media types.
  The client must be able to signal to the server what media type the server should expect for the request content en to use for the response content.
  This document only describes the use of [@!XML] but the use of other media types such as JSON [@!RFC7159] should also be possible.
  
- Compatibility with existing EPP commands and corresponding request and response messages.
- Simplicity, when the semantics of a resource URL and HTTP method match an EPP command and request message, the use of an request message should be optional.

- Performance, reducing the number of required request and response messages, improves the performance and network bandwidth requirements for both client and server. Fewer messages have to be created, marshalled and transmitted.

# EPP Extension Framework

[@!RFC3735, Section 2] of [@!RFC3735] describes how the EPP extension framework can be used to extend EPP functionality by adding new features at the protocol, object and command-response level. This section describes the impact of REPP on each of the extension levels:

- Protocol Extension: (#command-mapping) describes an protocol extension resource for use with existing and future protocol extensions. REPP does not define a new Protocol extension. All existing and future Protocol extension level EPP extensions MAY be used.

- Object extension: REPP does not define any new object level extensions. All existing and future object level EPP extensions MAY be used.

- Command-Response extension: 
 (#command-mapping) describes a Command-Response extension resource for each object mapping and can be used for existing and future command extensions. REPP does not define a new Command-Response extension. All existing and future Command-Response extension level EPP extensions MAY be used.

# Resource Naming Convention

A REPP resource can be a single unique object identifier e.g. a domain name, or consist out of a collection of objects. A collection of objects available for registry operations MUST be identified by: `/{context-root}/{version}/{collection}` 

- `{context-root}` is the base URL which MUST be specified, the {context-root} MAY be an empty, zero length string.

- `{version}` is a path segment which identifies the version of the REPP implementation. This
  is the equivalent of the Version element in the EPP RFCs. The version used in the REPP URL MUST match the version used in EPP Greeting message.

- `{collection}` MUST be substituted by "domains", "hosts" or
  "contacts" or other supported objects, referring to either [@!RFC5731], [@!RFC5732] or [@!RFC5733].

A trailing slash MAY be added to each request. Implementations MUST consider requests which only differ with respect to this trailing slash as identical.

A specific EPP object instance MUST be identified by {context-root}/ {version}/{collection}/{id} where {id} is a unique object identifier described in EPP RFCs.

An example domain name resource, for domain name example.nl, would look like this:

`/repp/v1/domains/example.nl`

The path segment after a collection path segment MUST be used to identify an object instance, the path segment after an object instance MUST be used to identify attributes or related collections of the object instance.

<!--TODO ISSUE 7: No need for XML payload for GET requests when URL identifies object -->
Reource URLs used by REPP contain embedded object identifiers. By using an object identifier in the resource URL, the object identifier in the request messages becomes superfluous. However, since the goal of REPP is to maintain compatibility with existing EPP object mapping schemas, this redundancy is accepted as a trade off. Removing the object identifier from the request message would require updating the object mapping schemas in the EPP RFCs.

The server MUST return HTTP status code 412 when the object identifier, for example domain:name, host:name or contact:id, in the EPP request message does not match the {id} object identifier embedded in the URL.
  <!--TODO: is this not mixing epp and http status codes? -->

# Session Management

One of the main design considerations for REPP is to enable scalable EPP services, for this reason the REPP uses a stateless architecture and does not create and maintain client sessions. The Session concept is considered to be an anti pattern in the context of a stateless service, the server MUST NOT maintain any state information relating to the client or EPP transaction.

Session management as described in [@!RFC5730] requires a stateful server architecture for maintaining client and application state over multiple client request and is therefore no longer supported.

A REPP request MUST contain all information required for the server to be able to successfully process the request. The client MUST include authentication credentials for each request. This MAY be done by using any of the available HTTP authentication mechanisms, such as those described in [@!RFC2617].

A REPP server MUST listen for HTTP connection requests on the standard TCP port assigned in [@!RFC2616]. After a connection has been established, the server MUST NOT return a Greeting message. The server MAY close open TCP connections when these violate server policies, for instance connections having a long inactivity period or a long connection lifetime. 

# REST {#rest}

REPP uses the REST architectural style, each HTTP method is assigned a distinct behaviour, (#http-method) provides a overview of the behaviour assigned to each method. REPP requests are expressed by a URL refering to a resource, a HTTP method, HTTP headers and an optional message body containing the EPP request message. 

<!--TODO ISSUE 10: allow for out of order processing -->
A REPP HTTP message body MUST contain at most a single EPP request or response. HTTP requests MUST be processed independently of each other and in the same order as received by the server. A client MAY choose to send a new request, using an existing connection, before the response for the previous request has been received (pipelining). A server using HTTP/2 [@!RFC7540] or HTTP/3 [@!RFC9114] contains builtin support for stream multiplexing and MAY choose to support pipelining using this mechanism. The response MAY be returned out of order back to the client, due to the fact that some requests require more processing time by the server.

HTTP/1 does not use persistent connections by default, the client MAY use the "Connection" header to request for the server not to close the existing connection, so it can be re-used for future requests. The server MAY choose not to honor this request.

## Method Definition {#http-method}

REPP commands MUST be executed by using an HTTP method on a resource identified by an URL. The server MUST support the following methods.

- GET: Request a representation of a object resource or a collection of resources
- PUT: Update an existing object resource
- PATCH: Partially update an existing object resource
- POST: Create a new object resource
- DELETE: Delete an existing object resource
- HEAD: Check for the existence of an object resource
- OPTIONS: Request a greeting

## Content negotiation 

  <!--TODO ISSUE 6:Allow for additional dataformat -->    
The server MAY choose to support multiple data format for EPP object representations, such as XML and JSON.
The client and server MUST support agent-driven content negotiation and related HTTP headers for content negotiation, as described in [@!RFC2616, section 12.2].
  
The client MUST use the following HTTP headers:

- `Content-Type`: Used to indicate the media type for the content in the message body 
- `Accept`: Used to indicate the media type the server MUST use for the representation of objects, this MAY
           be a list of types and related weight factors, as described in [@!RFC2616, section 14.1]

The client MUST synchronize the value for the Content-Type and Accept headers, for example a client MUST NOT send an XML formatted request message to the server, while at the same time requesting a JSON formatted response message. The server MUST use the `Content-Type` HTTP header to indicate the media type used for the representation in the response message body. The server MUST return HTTP status code 406 (Not Acceptable) or 415 (Unsupported Media Type) when the client requests an unsupported media type.

## Request

In contrast to EPP over TCP [@!RFC5734], a REPP request does not always require a EPP request message. The information conveyed by the HTTP method, URL and request headers is, for some use cases, sufficient for the server to be able to successfully proceses the request. The `Object Info` request for example, does not require an EPP message.
HTTP request headers are used to transmit additional or optional request data to the server. All REPP HTTP headers MUST have the "REPP-" prefix, following the recommendations in [@!RFC6648].

- `REPP-Cltrid`:  The client transaction identifier is the equivalent of the `clTRID` element defined in [@!RFC5730] and MUST be used accordingly when the HTTP message body does not contain an EPP request that includes a cltrid.

- `REPP-Svcs`: The namespace used by the client in the EPP request message, this is equivalent to the "svcs" element in the Login command defined in [@!RFC5730, section 2.9.1.1]. The client MUST use this header if the media type of the request or response message body content requires the server to know what namespaces to use. Such as is the case for XML-based request and response messages. The header value MAY contain multiple comma separated namespaces.
    <!--TODO issue #31: do we add all namespaces to this header, also for extensions or do we need another header for extension -->

- `REPP-Svcs-Ext`: The extension namespace used by the client in the EPP request message, this is equivalent to the "svcExtension" element in the Login command defined in [@!RFC5730, section 2.9.1.1]

- `REPP-AuthInfo`: The client MAY use this header for sending basic token-based authorization information, as described in [@!RFC5731, section 2.6] and [@!RFC5733, section 2.8]. If the authorization is linked to a contact object then the client MUST also include the REPP-Roid header.

- `REPP-Roid`: If the authorization info, is linked to a database object, the client MAY use this header for the Repository Object IDentifier (ROID), as described in [@!RFC5730, section 4.2].
  <!-- TODO issue #33 : use header for simple auth token -->

- `Accept-Language`:  This header is equivalent to the "lang" element of the EPP Login command. The server MUST support the use of HTTP Accept-Language header by clients. The client MAY issue a Hello request to discover the languages supported by the server. Multiple servers in a load-balanced environment SHOULD reply with consistent "lang" elements in the Greeting response. The value of the Accept-Language header MUST match 1 of the languages from the Greeting. When the server receives a request using an unsupported langauge, the server MUST respond using the default language configured for the server, as required in [@!RFC5730, section 2.9.1.1] 
 
- `Connection`: If the server uses HTTP/1.1 or lower, the CLIENT MAY choose to use this header to request the server to keep op the TCT-connection. The client MUST not use this header when the server uses HTTP/2 [@!RFC9113, section 8.2.2] or HTTP/3 [@!RFC9113, section 4.2]
  <!--TODO ISSUE 11: How to handle connections -->   

- `Accept-Encoding`: The client MAY choose to use the Accept-Encoding HTTP header to request the server to use compression for the response message body.

  <!--TODO ISSUE 4: also include authentication header here? -->

## Response

The server HTTP response contains a status code, headers and MAY contain an EPP response message in the message body. HTTP headers are used to transmit additional data to the client and MAY be used to send EPP process related data to the client. HTTP headers used by REPP MUST use the "REPP-" prefix, the following response headers have been defined for REPP.

- `REPP-Svtrid`:  This header is the equivalent of the "svTRID" element defined in [@!RFC5730] and MUST be used accordingly when the REPP response does not contain an EPP response in the HTTP message body. If an HTTP message body with the EPP XML equivalent "svTRID" exists, both values MUST be consistent.

- `REPP-Cltrid`: This header is the equivalent of the "clTRID" element defined in [@!RFC5730] and MUST be used accordingly when the REPP response does not contain an EPP response in the HTTP message body. If the contents of the HTTP message body contains a "clTRID" value, then both values MUST be consistent.
  
- `REPP-Eppcode`: This header is the equivalent of the EPP result code defined in [@!RFC5730] and MUST be used accordingly. This header MUST be added to all responses, except for the Greeting, and MAY be used by the client for easy access to the EPP result code, without having to parse the content of the HTTP response message body.

- `REPP-Check-Avail`: An alternative for the "avail" attribute of the object:name element in an Object Check response and MUST be used accordingly. The server does not return a HTTP message body in response to a REPP Object Check request.   

- `REPP-Check-Reason`: An optional alternative for the "object:reason" element in an Object Check response and MUST be used accordingly.

- `REPP-Queue-Size`: Return the number of unackknowledged messages in the client message queue. The server MAY include this header in all REPP responses.
    <!--TODO ISSUE 40: return queue size for all results-->   

- `Cache-Control`:  The client MUST never cache results, the server MUST always return the value "No-Store" for this header, as described in [@!RFC7234, section 5.2.1.5].
   <!--TODO ISSUE 10: How to handle caching -->   

- `Content-Language`: The server MUST include this header in every response that contains an EPP message in the message body.

- `Content-Encoding`: The server MAY choose to compresses the responses message body, using a algorithm selected from the list of algorithms provided by the client using the Accept-Encoding request header.

REPP does not always return an EPP response message in the HTTP message body. The `Object Check` request for example may return an empty HTTP response body. When the server does not return a EPP message, it MUST return at least the REPP-Svtrid, REPP-Cltrid and REPP-Eppcode headers.

## Error Handling {#error-handling}

  <!--TODO: ISSUE #35: Mapping EPP code to HTTP status codes -->
Restful EPP and HTTP protocol are both an application layer protocol, having their own status- and result codes. The endpoints described in (#command-mapping) MUST return HTTP status code 200 (OK) for successful requests when the EPP result code indicates a positive completion (1xxx) of the EPP command.

When an EPP command results in a negative completion result code (2xxx), the server MUST return the HTTP status code 422 (Unprocessable Content). A more detailed explanation of the EPP error MUST be included in the message body of the HTTP response, as described in [@!RFC9110], but only when this is permitted for the used HTTP method. Errors related to the HTTP protocol MUST result in the use of an apropriate HTTP status code by the HTTP server. An error or problem while processing one request MUST NOT result in the failure of other independent requests using the same connection.

The client MUST be able to use the best practices for RESTful applications and use the HTTP status code to determine if the EPP request was successfully processed. The client MAY use the well defined HTTP status code and REPP-Eppcode HTTP header for error handling logic, without having to parse the EPP result code in the message body. 

For example, a client sending an Object Tranfer request for an Object already linked to an active transfer process, will result in an EPP result code 2106, the HTTP response contains a status code 422 and he value for the REPP-Eppcode HTTP header is set to 2106. The client MAY use the HTTP status code for checking if an EPP command failed and only parse the result message when additional information from the response message is required for handling the error.

# Command Mapping {#command-mapping}

EPP commands are mapped to RESTful EPP requests using four elements.

1. Resource defined by a URL
2. HTTP method to be used on the resource
3. EPP request message
4. EPP response message

(#tbl-cmd-mapping) lists a mapping for each EPP command to a REPP request, the subsequent sections provide details for each request. Resource URLs in the table are assumed to be using the prefix: "/{context-root}/{version}/". Some REPP endpoints do not require a request and/or response message, as is indicated by the table columns "Request" and "response". 

- `{c}`:  An abbreviation for {collection}: this MUST be substituted with
  "domains", "hosts", "contacts" or any other collection of objects.
- `{i}`:  An abbreviation for an object id, this MUST be substituted with the value of a domain name, hostname, contact-id or a message-id or any other defined object.

{#tbl-cmd-mapping}
Command            | Method   | Resource                  | Request     | Response
-------------------|----------|---------------------------|-------------|-----------------
Hello              | OPTIONS  | /                         | No          | Yes
Login              | N/A      | N/A                       | N/A         | N/A
Logout             | N/A      | N/A                       | N/A         | N/A
Check              | HEAD     | /{c}/{i}                  | No          | No
Info               | GET      | /{c}/{i}                  | No          | Yes
Poll Request       | GET      | /messages                 | No          | Yes
Poll Ack           | DELETE   | /messages/{i}             | No          | Yes
Create             | POST     | /{c}                      | Yes         | Yes
Delete             | DELETE   | /{c}/{i}                  | No          | Yes
Renew              | POST     | /{c}/{i}/renewals         | No          | Yes
Transfer Request   | POST     | /{c}/{i}/transfers        | No          | Yes
Transfer Query     | GET      | /{c}/{i}/transfers/latest | No          | Yes
Transfer Cancel    | DELETE   | /{c}/{i}/transfers/latest | No          | Yes
Transfer Approve   | PUT      | /{c}/{i}/transfers/latest | No          | Yes
Transfer Reject    | DELETE   | /{c}/{i}/transfers/latest | No          | Yes
Update             | PATCH    | /{c}/{i}                  | Yes         | Yes
Extension [1]      | *        | /{c}/{i}/extension/*      | *           | *
Extension [2]      | *        | /extension/*              | *           | *
Table: Mapping of EPP Command to REPP Request

[1] This mapping is used for Object extensions based on the extension mechanism as defined in [RFC5730, secion 2.7.2] 
[2] This mapping is used for Protocol extensions based on the extension mechanism as defined in [RFC5730, secion 2.7.1] 

When there is a mismatch between a resource identifier in the HTTP message body and the resource identifier in the URL used for a request, then the server MUST return HTTP status code 400 (Bad Request).

## Hello

- Request: OPTIONS /
- Request message: None
- Response message: Greeting response

Due to the stateless nature of REPP, the server does not respond by sending a Greeting message when a connection is created, as described in [@!RFC5730, section 2]. The client MUST request a Greeting by using the Hello request as described in [@!RFC5730, section 2.3]. The server MUST respond by returning a Greeting response, as defined in [@!RFC5730, section 2.4].

The version value used in the Hello response MUST match the version value used for the `{version}` path segment in the URL used for the Hello request.

Example request:

```
C: OPTIONS /repp/v1/ HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: Connection: keep-alive

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 799
S: Content-Type: application/epp+xml
S: Content-Language: en
S:
S: <?xml version="1.0" encoding="UTF-8" standalone="no"?>
S: <epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:   <greeting>
S:      <svcMenu>
S:         <version>1.0</version>
S:         <!-- The rest of the response is omitted here -->
S:      <svcMenu>
S:   </greeting>
S: </epp>
```

##  Login

The Login command defined in [@!RFC5730, section 2.9.1.1] is used to establish a session between client and server, this is part of the stateful nature of the EPP protocol. REPP is stateless and MUST NOT maintain any client state and does not include a Login command. The client MUST include all information in a REPP request, required for the server to be able to properly process the request. This includes request attributes defined as for Login command in [@!RFC5730, section 2.9.1.1].

  <!--TODO ISSUE #16: do we support changing password using /password  -->
The request attributes from the Login command, used for configuring the client session, are are moved to the HTTP layer.

- `clID`: Replaced by HTTP authentication
- `pw:`: Replaced by HTTP authentication
- `newPW`: Replaced by out of band process
- `version`: Replaced by the `{version}` path parameter in the request URL.
- `lang`: Replaced by the `Accept-Language` HTTP header.
- `svcs`: Replaced by the `REPP-Svcs` HTTP header.
- `svcExtension`:  Replaced by the `REPP-Svcs-Ext` HTTP header.

The server MUST check the namespaces used in the REPP-Svcs HTTP header. An unsupported namespace MUST result in the appropriate EPP result code.

##  Logout

Due to the stateless nature of REPP, the session concept is no longer used and therefore the Logout command MUST NOT be implemented by the server.

## Query Resources

   <!--TODO: ISSUE #9: How to handle authInfo data for INFO command (GET request)? -->
A REPP client MAY use the HTTP GET method for executing a query command only when no request data has to be added to the HTTP message body. Sending content using an HTTP GET request is discouraged in [@!RFC9110], there exists no generally defined semanticsfor content received in a GET request. When an EPP object requires additional authInfo information, as described in [@!RFC5731] and [@!RFC5733], the client MUST use the HTTP POST method and add the query command content to the HTTP message body.

### Check

- Request: HEAD /{collection}/{id}
- Request message: None
- Response message: None

 The HTTP HEAD method MUST be used for object existence check. Both client and server MUST NOT add content to the HTTP message body. The response MUST contain the `REPP-Check-Avail` header and MAY contain the `REPP-Check-Reason` header. The value of the `REPP-Check-Avail` header MUST be "0" or "1" as described in [@!RFC5730, section 2.9.2.1], depending on whether the object can be provisioned or not. 

The Check endpoint MUST be limited to checking only a single object-id per request. This may seem a limitation compared to the Check command defined in [@!RFC5730] where a Check message may contain multiple object-ids. The REPP Check request can be load balanced more efficiently when only a single object-id has to be checked. 

Example request for a domain name:

```
C: HEAD /repp/v1/domains/example.nl HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```
Example response:

```
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: REPP-Cltrid: ABC-12345
S: REPP-Svtrid: XYZ-12345
S: REPP-Check-Avail: 0
S: REPP-Check-Reason: In use
S: REPP-result-code: 1000

```

### Info

The Object Info request MUST use the HTTP GET method on a resource identifying an object instance, using an empty message body. If the object has authorization information attachted and the authorization then the client MUST include the REPP-AuthInfo HTTP header. If the authorization is linked to a database object the client MUST include the REPP-Roid header.

Example request for an object not using authorization information.  

- Request: GET /{collection}/{id}
- Request message: None
- Response message: Info response

```
C: GET /repp/v1/domains/example.nl HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

Example request using REPP-AuthInfo header for an object that has attached authorization information.  

- Request: GET /{collection}/{id}
- Request message: None
- Response message: Info response

```
C: GET /repp/v1/domains/example.nl HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: REPP-AuthInfo: secret-token
C: REPP-Roid: REG-XYZ-12345
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

Example Info response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 424
S: Content-Type: application/epp+xml
S: Content-Language: en
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <resData>
S:      <domain:infData xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
S:         < !-- The rest of the response is omitted here -- >
S:      </domain:infData>
S:    </resData>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```


#### Object Filtering

  <!-- TODO: ISSIE #42: make filtering generic -->
The server MUST support the use of the `filter` and `val` query parameters for the purpose of limiting the number of objects in a response.

- `filter`: The attribute or field name to apply the filter on
- `val`: The value used for filtering

The Domain Name Mapping [@!RFC5731, Section 3.1.2] describes an optional "hosts" attribute for the Domain Info command. This attribute may be used for filtering hosts returned in the Info response, and is mapped to the `filter` and `val` query parameters. If the filtering query parameters are absent from the request URL, the server MUST use the default filter value described in the corresponding EPP RFCs.

URLs used for filtering based on `hosts` attribute for Domain Info request:

-  default: GET /domains/{id}
-  all: GET /domains/{id}?filter=hosts&val=all
-  del: GET /domains/{id}?filter=hosts&val=del
-  sub: GET /domains/{id}?filter=hosts&val=sub
-  none: GET /domains/{id}?filter=hosts&val=none

Example Domain Info request, the response should only include delegated hosts:

```
C: GET /repp/v1/domains/example.nl?filter=hosts&val=del HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

### Poll

#### Poll Request

- Request: GET /messages
- Request message: None
- Response message: Poll response

The client MUST use the HTTP GET method on the messages resource collection to request the message at the head of the queue. The "op=req" semantics from [@!RFC5730, Section 2.9.2.3] are assigned to the HTTP GET method.

Example request:

```
C: GET /repp/v1/messages HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345

```
Example response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 312
S: Content-Type: application/epp+xml
S: Content-Language: en
S: REPP-Eppcode: 1301
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1301">
S:      <msg>Command completed successfully; ack to dequeue</msg>
S:    </result>
S:    <msgQ count="5" id="12345">
S:      <qDate>2000-06-08T22:00:00.0Z</qDate>
S:      <msg>Transfer requested.</msg>
S:    </msgQ>
S:    <resData>
S:       <!-- The rest of the response is omitted here -->
S:    </resData>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

#### Poll Ack

- Request: DELETE /messages/{id}
- Request message: None
- Response message: Poll Ack response

The client MUST use the HTTP DELETE method to acknowledge receipt of a message from the queue. The "op=ack" semantics from [@!RFC5730, Section 2.9.2.3] are assigned to the HTTP DELETE method. The "msgID" attribute of a received EPP Poll message MUST be included in the message resource URL, using the {id} path element. The server MUST use REPP headers to return the EPP result code and the number of messages left in the queue. The server MUST NOT add content to the HTTP message body of a successfull response, the server may add content to the message body of an error response. 

Example request:

```
C: DELETE /repp/v1/messages/12345 HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345

```
Example response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Language: en
S: REPP-Eppcode: 1000
S: REPP-Queue-Size: 0
S: REPP-Svtrid: XYZ-12345
S: REPP-Cltrid: ABC-12345
S: Content-Length: 145
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <msgQ count="0" id="12345"/>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

### Transfer Query

The Transfer Query request MUST use the special "latest" sub-resource to refer to the
latest object transfer. A latest transfer object may not exist, when no transfer has been initiated for the specified object. The client MUST use the HTTP GET method and MUST NOT add content to the HTTP message body.

- Request: GET {collection}/{id}/transfers/latest
- Request message: None
- Response message: Transfer Query response

Example domain name Transfer Query request without authorization information required:

```
C: GET /repp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

If the requested object has associated authorization information that is not linked to another database object, then the HTTP GET method MUST be used and the authorization information MUST be included using the REPP-AuthInfo header.

Example domain name Transfer Query request using REPP-AuthInfo header:

```
C: GET /repp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: REPP-AuthInfo: secret-token
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

If the requested object has associated authorization information linked to another database object, then the HTTP GET method MUST be used and both the REPP-AuthInfo and the REPP-Roid header MUST be included. 

Example domain name Transfer Query request and authorization using REPP-AuthInfo and the REPP-Roid header:

```
C: GET /repp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-AuthInfo: secret-token
C: REPP-Roid: REG-XYZ-12345
C: Content-Length: 0
C:
```

Example Transfer Query response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 230
S: Content-Type: application/epp+xml
S: Content-Language: en
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <resData>
S:      <!-- The rest of the response is omitted here -->
S:    </resData>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

## Transform Resources

### Create

- Request: POST /{collection}
- Request message: Object Create request
- Response message: Object Create response

The client MUST use the HTTP POST method to create a new object resource. If the EPP request results in a newly created object, then the server MUST return HTTP status code 200 (OK). The server MUST add the "Location" header to the response, the value of this header MUST be the URL for the newly created resource.

Example Domain Create request:

```xml
C: POST /repp/v1/domains HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 220
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
C:  <command>
C:    <create>
C:      <domain:create
C:       xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
C:        <domain:name>example.nl</domain:name>
C:        <!-- The rest of the request is omitted here -->
C:      </domain:create>
C:    </create>
C:    <clTRID>ABC-12345</clTRID>
C:  </command>
C:</epp>
```

Example Domain Create response:

```xml
S: HTTP/2 200
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Language: en
S: Content-Length: 642
S: Content-Type: application/epp+xml
S: Location: https://repp.example.nl/repp/v1/domains/example.nl
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0"
S:     xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
S:   <response>
S:      <result code="1000">
S:         <msg>Command completed successfully</msg>
S:      </result>
S:      <resData>
S:         <domain:creData>
S:            <!-- The rest of the response is omitted here -->
S:         </domain:creData>
S:      </resData>
S:      <trID>
S:         <clTRID>ABC-12345</clTRID>
S:         <svTRID>54321-XYZ</svTRID>
S:      </trID>
S:   </response>
S:</epp>
```

### Delete

- Request: DELETE /{collection}/{id} 
- Request message: None
- Response message: Status

The client MUST the HTTP DELETE method and a resource identifying a unique object instance. The server MUST return HTTP status code 200 (OK) if the resource was deleted successfully.

Example Domain Delete request:

```
C: DELETE /repp/v1/domains/example.nl HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345

```

Example Domain Delete response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 80
S: REPP-Svtrid: XYZ-12345
S: REPP-Cltrid: ABC-12345
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

### Renew

- Request: POST /{collection}/{id}/renewals
- Request message: None
- Response message: Renew response

The Renew command is mapped to a nested collection, named "renewals". Not all EPP object types include support for the renew command. The current-date query parameter MAY be used for date on which the current validity period ends, as described in [@!RFC5731, section 3.2.3]. The new period MAY be added to the request using the unit and value request parameters. The reponse MUST include the Location header for the renewed object.

Example Domain Renew request:

```
C: POST /repp/v1/domains/example.nl/renewals?current-date=2024-01-01 HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 0
C: 
```

Example Domain Renew request, using 1 year period:

```
C: POST /repp/v1/domains/example.nl/renewals?current-date=2024-01-01?unit=y&value=1 HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 0
C: 
```

Example Renew response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Language: en
S: Content-Length: 205
S: Location: https://repp.example.nl/repp/v1/domains/example.nl
S: Content-Type: application/epp+xml
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <resData>
S:      <!-- The rest of the response is omitted here -->
S:    </resData>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

### Transfer

Transferring an object from one sponsoring client to another client is specified in [@!RFC5731] and [@!RFC5733]. The Transfer command is mapped to a nested resource, named "transfers". The semantics of the HTTP DELETE method are determined by the role of the client executing the DELETE method. For the current sponsoring client of the object, the DELETE method is defined as "reject transfer". For the new sponsoring client the DELETE method is defined as "cancel transfer".

#### Request

- Request: POST /{collection}/{id}/transfers
- Request message: None
- Response message: Status

To start a new object transfer process, the client MUST use the HTTP POST method for a unique resource to create a new transfer resource object, not all EPP objects support the Transfer command as described in [@!RFC5730, section 3.2.4], [@!RFC5731, section 3.2.4] and [@!RFC5733, section 3.2.4].

If the transfer request is successful, then the reponse MUST include the Location header for the object being transferred.

Example request not using object authorization:

```
C: POST /repp/v1/domains/example.nl/transfers HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: Content-Length: 0

```

Example request using object authorization:

```xml
C: POST /repp/v1/domains/example.nl/transfers HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: REPP-Cltrid: ABC-12345
C: REPP-AuthInfo: secret-token
C: Accept-Language: en
C: Content-Length: 0

```

Example request using 1 year renewal period, using the `unit` and `value` query parameters:

```
C: POST /repp/v1/domains/example.nl/transfers?unit=y&value=1 HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: Content-Length: 0

```

<!--
Example request using object authorization linked to a contact object:

```xml
C: POST /repp/v1/domains/example.nl/transfers HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 252
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
C:  <command>
C:    <transfer op="request">
C:      <domain:transfer
C:       xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
C:        <domain:name>example.nl</domain:name>
C:        <domain:authInfo>
C:          <domain:pw roid="DOM-12345">secret</domain:pw>
C:        </domain:authInfo>
C:      </domain:transfer>
C:    </transfer>
C:    <clTRID>ABC-12345</clTRID>
C:  </command>
C:</epp>
```
-->

Example Transfer response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Language: en
S: Content-Length: 328
S: Content-Type: application/epp+xml
S: Location: https://repp.example.nl/repp/v1/domains/example.nl/transfers/latest
S: REPP-Eppcode: 1001
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1001">
S:      <msg>Command completed successfully; action pending</msg>
S:    </result>
S:    <resData>
S:      <!-- The rest of the response is omitted here -->
S:    </resData>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```


#### Cancel

- Request: DELETE /{collection}/{id}/transfers/latest
- Request message: None
- Response message: Status

The new sponsoring client MUST use the HTTP DELETE method to cancel a requested transfer. The semantics of the HTTP DELETE method are determined by the role of the client sending the request.

Example request:

```
C: DELETE /repp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 80
S: REPP-Svtrid: XYZ-12345
S: REPP-Cltrid: ABC-12345
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

#### Reject

- Request: DELETE /{collection}/{id}/transfers/latest
- Request message:  None
- Response message: Status

The semantics of the HTTP DELETE method are determined by the role of the client sending the request. For the current sponsoring client of the object, the DELETE method is defined as "reject transfer".

Example request:

```
C: DELETE /repp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345

```

Example Reject response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 80
S: REPP-Svtrid: XYZ-12345
S: REPP-Cltrid: ABC-12345
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>

```

#### Approve

- Request: PUT /{collection}/{id}/transfers/latest
- Request message: None
- Response message: Status

The current sponsoring client MUST use the HTTP PUT method to approve a transfer requested by the new sponsoring client.

Example Approve request:

```
C: PUT /repp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Cltrid: ABC-12345
C: Content-Length: 0

```

Example Approve response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 80
S: REPP-Svtrid: XYZ-12345
S: REPP-Cltrid: ABC-12345
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

### Update

- Request: PATCH /{collection}/{id}
- Request message: Object Update message
- Response message: Status

An object Update request MUST be performed using the HTTP PATCH method. The request message body MUST contain an EPP Update request, and the object-id value in the request MUST match the value of the object-id path parameter in the URL.

Example request:

```xml
C: PATCH /repp/v1/domains/example.nl HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: Accept-Language: en
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Content-Length: 252
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
C:  <command>
C:    <update>
C:      <domain:update
C:       xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
C:        <domain:name>example.nl</domain:name>
C:           <!-- The rest of the request is omitted here -->
C:      </domain:update>
C:    </update>
C:    <clTRID>ABC-12345</clTRID>
C:  </command>
C:</epp>
```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Length: 80
S: REPP-Svtrid: XYZ-12345
S: REPP-Cltrid: ABC-12345
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

## Extension Framework

The EPP Extension Framework allows for extending the EPP protocol at different locations, REPP defines additional REST resources for the Protocol and Command-Response extensions.

### Protocol Extension

- Request: * /extensions/*
- Request message: *
- Response message: *

EPP Protocol extensions, defined in [@!RFC5730, section 2.7.1] are supported using the "/extensions" root resource.
The HTTP method used for a new Protocol extension is not defined but must follow the RESTful principles.

The example below, illustrates the use of the "Domain Cancel Delete" command as defined as a custom command in [@?SIDN-EXT]. The new command is created below the "extensions" path element and after this element follows the "domains" object collection, finally a special "deletion" path element is added to the end of the URL. A client MUST use the HTPP DELETE method on a domain name deletion resource to cancel an ongoing domain delete transaction and move the domain from the grace state back to the active state.

Example Protocol Extension request:

- Request: DELETE /extensions/{collection}/{id}/deletion
- Request message: None
- Response message: Optional error response

```
C: DELETE /repp/v1/extensions/domains/example.nl/deletion HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: REPP-Svcs-Ext: https://rxsd.domain-registry.nl/sidn-ext-epp-1.0
C: REPP-Cltrid: ABC-12345

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Language: en
S: Content-Length: 0
S: REPP-Svtrid: XYZ-12345
S: REPP-Cltrid: ABC-12345
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</epp>
```

### Object Extension

An Object extension is differs from the other 2 extension types in the way that an Object extension is implemented using a new Object mapping for a new Object type, while re-using the existing EPP command and response structures. The newly created Object mapping, is similar to the existing Object mappings defined in [@!RFC5731], [@!RFC5732] and [@!RFC5733], and MUST be used in a similar fashion.

A hypothetical new Object mapping for IP addresses, may result in a new resource collection named "ips", the semantics for the HTTP methods would have to be defined. Creating a new IP address may use the HTTP POST method on the "ips" collection.

- Request: POST /{collection}/{id}
- Request message: IP Create Request message
- Response message: IP Create Response message

Example request:

```xml
C: POST /repp/v1/ips HTTP/2
C: Host: repp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: REPP-Svcs-Ext: https://example.nl/epp-ips-1.0
C: REPP-Cltrid: ABC-12345
C: Content-Type: application/epp+xml
C: Content-Length: 220
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0">
C:  <command>
C:    <create>
C:      <ips:create
C:       xmlns:ip="https://example.nl/epp-ips-1.0">
C:        <ips:address>192.0.2.1</ips:address>
C:        <!-- The rest of the request is omitted here -->
C:      </ips:create>
C:    </create>
C:    <clTRID>ABC-12345</clTRID>
C:  </command>
C:</epp>

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Fri, 17 Nov 2023 12:00:00 UTC
S: Server: Example REPP server v1.0
S: Content-Language: en
S: Content-Length: 642
S: Content-Type: application/epp+xml
S: Location: https://repp.example.nl/repp/v1/ips/192.0.2.1
S: REPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<epp xmlns="urn:ietf:params:xml:ns:epp-1.0"
S:     xmlns:ips="https://example.nl/epp-ips-1.0">
S:   <response>
S:      <result code="1000">
S:         <msg>Command completed successfully</msg>
S:      </result>
S:      <resData>
S:         <ips:creData>
S:            <!-- The rest of the response is omitted here -->
S:         </ips:creData>
S:      </resData>
S:      <trID>
S:         <clTRID>ABC-12345</clTRID>
S:         <svTRID>54321-XYZ</svTRID>
S:      </trID>
S:   </response>
S:</epp>

```
 
### Command-Response Extension

Command-Response Extensions allow for adding elements to an existing object mapping, therefore no new extension reource is required, the existing resources can be used for existing and future extensions of this type.  

# Transport Mapping Considerations

  <!--TODO ISSUE #2: not all considerations are met by repp? -->
  <!--TODO ISSUE #36: create update for this section in rfc5730 -->

[@!RFC5730, section 2.1] of the EPP protocol specification describes considerations to be addressed by a protocol transport mapping.
These considerations are satisfied by a combination of REPP features and features provided by HTTP and underlying transport protocols.

- The consideration: "The transport mapping MUST preserve the stateful nature of the protocol", is updated to: "The transport mapping MUST preserve the stateful nature of the protocol, when using a stateful transport protocol". REPP uses the REST architectural style for defining a stateless API based on the stateless HTTP protocol, and therefore satisfies the updated consideration. 

- (#rest) describes how HTTP multiplexing may be used for pipelining multiple requests. A server may allow pipelining, requests are to be processed in the order they have been received.

- REPP is based on the HTTP protocol, which uses the client-server model.
- REPP requests are transmitted using HTTP, this document refrers to the HTTP protocol specification for how data units are framed.
- HTTP/1 and HTTP/2 use TCP as a transport protocol and this includes features to provide reliability, flow control, ordered delivery, and congestion control [@!RFC793, section 1.5] describes these features in detail; congestion control principles are described further in [@!RFC2581] and [@!RFC2914]. HTTP/3 is uses QUIC (UDP) as a transport protocol, which has builtin congestion control over UDP.

- Section (#rest) describes how requests are processed independently of each other.
- Errors while processing a REPP request are isolated to this request and do not effect other requests sent by the client or other clients, this is described in section (#error-handling).

-  Batch-oriented processing (combining multiple EPP commands in a single HTTP request) is not permitted. To maximize scalability
   every request must contain a single command, as described in section (#rest).


# IANA Considerations

[TBD: at the moment we don't see any] 

# Internationalization Considerations

[TBD: any? Accept-Language in HTTP Header]

# Security Considerations

Data confidentiality and integrity MUST be enforced, all data transport between a client and server MUST be encrypted using TLS [@!RFC5246]. [@!RFC5734, Section 9] describes the level of security that is REQUIRED for all REPP endpoints.

The EPP Login command, described by [@!RFC5730], for creating a client session MUST NOT be used anymore. Due to the stateless nature of REPP, the client MUST include the authentication credentials in each HTTP request. This MAY be done by using JSON Web Tokens (JWT) [@!RFC7519] or Basic authentication [@!RFC7617].

The management of authentication credentials, such as the "Change password" functionality of the EPP Login command, MUST be performed by an out-of-band process. REPP (HTTP) servers are vulnerable to common denial-of-service attacks. Therefore, the security considerations of [@!RFC5734] also apply to REPP.


# Obsolete EPP Result Codes

The following EPP result codes specified in [@!RFC5730] are no longer
meaningful in the context of RESTful EPP and MUST NOT be used.

| Code | Reason                                                     
------|------------------------------------------------------------
| 1500 | Authentication functionality is delegated to the HTTP protocol layer                
| 2100 | The REPP URL includes a path segment for the version
| 2200 | Authentication functionality is delegated to the HTTP protocol layer           
| 2501 | Authentication functionality is delegated to the HTTP protocol layer 
| 2502 | Rate limiting functionality is delegated to the HTTP protocol layer    
Table: Obsolete EPP result codes

# Acknowledgments

The authors would like to thank Miek Gieben who worked with us on an earlier, similar draft.

{backmatter}

<reference anchor="REST" target="http://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm">
  <front>
    <title>Architectural Styles and the Design of Network-based Software Architectures</title>
    <author initials="R." surname="Fielding" fullname="Roy Fielding">
      <organization/>
    </author>
    <date year="2000"/>
  </front>
</reference>

<reference anchor="YAML" target="https://yaml.org/spec/1.2.2/">
  <front>
    <title>YAML: YAML Ain't Markup Language</title>
    <author>
      <organization>YAML Language Development Team</organization>
    </author>
    <date year="2000"/>
  </front>
</reference>

<reference anchor="SIDN-EXT" target="http://rxsd.domain-registry.nl/sidn-ext-epp-1.0.xsd">
  <front>
    <title>Extensible Provisioning Protocol v1.0 schema .NL extensions</title>
    <author>
      <organization>SIDN</organization>
    </author>
    <date year="2019"/>
  </front>
</reference>

<reference anchor="XML" target="https://www.w3.org/TR/xml">
  <front>
    <title>Extensible Markup Language (XML) 1.0 (Fifth Edition)</title>
    <author>
      <organization>W3C</organization>
    </author>
    <date year="2013"/>
  </front>
</reference>
