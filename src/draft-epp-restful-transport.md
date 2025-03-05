%%%
title = "RESTful Provisioning Protocol (RPP)"
abbrev = "RESTful Provisioning Protocol"
area = "Internet"
workgroup = "Network Working Group"
submissiontype = "IETF"
keyword = [""]
TocDepth = 4

[seriesInfo]
name = "Internet-Draft"
value = "draft-wullink-restful-epp-02"
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
initials="P."
surname="Kowalik"
fullname="Pawel Kowalik"
abbrev = ""
organization = "DENIC"
  [author.address]
  email = "pawel.kowalik@denic.de"
  uri = "https://denic.de/"

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

This document describes RESTful Provisioning Protocol (RPP), a data format agnostic, REST based Application Programming Interface (API) for the Extensible Provisioning Protocol [@!RFC5730]. RPP enables the development of a stateless and scalable EPP service.

This document includes a mapping of [@!RFC5730] [@!XML] EPP commands to a RESTful HTTP based interface. Existing semantics as defined in [@!RFC5731], [@!RFC5732] and [@!RFC5733] are retained and reused in RESTful Provisioning Protocol. 

{mainmatter}

# Introduction

This document describes an Application Programming Interface (API) for the Extensible Provisioning Protocol (EPP) protocol described in [@!RFC5730]. The API leverages the HTTP protocol [@!RFC2616] and the principles of [@!REST]. Conforming to the REST constraints is generally referred to as being "RESTful". Hence the API is dubbed: "'RESTful Provisioning Protocol" or "RPP" for short.

RPP includes a mapping of [@!RFC5730] EPP commands to REST resources based on Uniform Resource Locators (URLs) defined in [@!RFC1738]. RPP uses a stateless architecture. It aims to provide a solution that is more suitable for complex, high availability environments.

[@!RFC5730, Section 2.1] of [@!RFC5730] describes how EPP can be layered over multiple transport protocols. Currently, EPP transport over TCP [@!RFC5734] is the only widely deployed transport mapping for EPP. [@!RFC5730, Section 2.1] furthermore requires that newly defined transport mappings preserve the stateful nature of EPP. This document updates this requirement to also allow stateless for EPP transport.

The stateless nature of RPP requires that no client or application state is maintained on the server. Each client request to the server must contain all the information necessary for the server to process the request.

RPP is data format agnostic, the client uses server-driven content negotiation. Allowing the client to select from a set of representation media types supported by the server, such as XML, JSON [@!RFC8259] or [@!YAML].

# Terminology

In this document the following terminology is used.

REST - Representational State Transfer ([@!REST]). An architectural style.

RESTful - A RESTful web service is a web service or API implemented using HTTP and the principles of [@!REST].

EPP RFCs - This is a reference to the EPP version 1.0 specifications [@!RFC5730], [@!RFC5731], [@!RFC5732] and [@!RFC5733].

Stateful EPP - The definition according to [@!RFC5730, section 2].

RESTful Provisioning Protocol or RPP - The RESTful transport for EPP described in this document.

URL - A Uniform Resource Locator as defined in [@!RFC3986].

Resource - An object having a type, data, and possible relationship to other resources, identified by a URL.

Command Mapping - A mapping of [@!RFC5730] EPP commands to RESTful Provisioning Protocol URL resources.

RPP client - An HTTP user agent performing an RPP request 

RPP server - An HTTP server responsible for processing requests and returning results in any supported media type.


# Conventions Used in This Document

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT","SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [@!RFC2119].

XML is case sensitive. Unless stated otherwise, XML specifications and examples provided in this document MUST be interpreted in the character case presented to develop a conforming implementation.

The examples in this document assume that request and response messages are properly formatted XML documents.  

In examples, lines starting with "C:" represent data sent by a RPP client and lines starting with "S:" represent data returned by a RPP server. Indentation and white space in examples are provided only to illustrate element relationships and are not REQUIRED features of the protocol.

All example requests assume a RPP server using HTTP version 2 is listening on the standard HTTPS port on host rppp.example.nl. An authorization token has been provided by an out of band process and MUST be used by the client to authenticate each request.

# Design Considerations

RESTful transport for EPP (RPP) is designed to improve the ease of design, development, deployment, and management
of an EPP service. This section lists the main design criteria.

- Ease of use, provide a clear, clean, easy to use and self-explanatory interface that can easily be integrated into existing software systems. Based on these principles a [@!REST] architectural style was chosen, where a client  interacts with a RPP server via HTTP.

- Scalability, HTTP allows the use of well know mechanisms for creating scalable systems, such as 
  load balancing. Load balancing at the level of request messages is more efficient compared to load balancing based on TCP sessions. When using EPP over TCP, the TCP session can be used to transmit multiple request messages and these are then all processed by a single EPP server and not load balanced across a pool of available servers. During normal registry operations, the bulk of EPP requests can be expected to be of the informational type, load balancing and possibly separating these to dedicated compute resources may also improve registry services and provide better performance for the transform request types.   

- Stateless, [@!RFC5730] REQUIRES a stateful session between a client and server. A RPP server MUST be stateless and MUST NOT keep client session or any other application state. Each client request needs to provide all the information necessary for the server to successfully process the request.

- Security, allow for the use of authentication and authorization solutions available 
  for HTTP based applications. HTTP provides an Authorization header [@!RFC2616, section 14.8].

- Content negotiation, A server may choose to include support for multiple media types.
  The client must be able to signal to the server what media type the server should expect for the request content and to use for the response content.
  This document only describes the use of [@!XML] but the use of other media types such as JSON [@!RFC7159] should also be possible.
  
- Compatibility with existing EPP semantics defined in the EPP RFCs.
- Simplicity, when the semantics of a resource URL and HTTP method match an EPP command and request message, the use of a request message should be optional.

- Performance, reducing the number of required request and response messages, improves the performance and network bandwidth requirements for both client and server. Fewer messages have to be created, marshalled, and transmitted.

# EPP Extension Framework

[@!RFC3735, Section 2] of [@!RFC3735] describes how the EPP extension framework can be used to extend EPP functionality by adding new features at the protocol, object and command-response level. This section describes the impact of RPP on each of the extension levels:

- Protocol Extension: (#command-mapping) describes a protocol extension resource for use with existing and future protocol extensions. RPP does not define a new Protocol extension. All existing and future Protocol extension level EPP extensions MAY be used.

- Object extension: RPP does not define any new object level extensions. All existing and future object level EPP extensions MAY be used.

- Command-Response extension: 
 (#command-mapping) describes a Command-Response extension resource for each object mapping and can be used for existing and future command extensions. RPP does not define a new Command-Response extension. All existing and future Command-Response extension level EPP extensions MAY be used.

# Resource Naming Convention

A RPP resource can be a single unique object identifier e.g. a domain name or consist out of a collection of objects. A collection of objects available for registry operations MUST be identified by: `/{context-root}/{version}/{collection}` 

- `{context-root}` is the base URL which MUST be specified, the {context-root} MAY be an empty, zero length string.

- `{version}` is a path segment which identifies the version of the RPP implementation. This
  is the equivalent of the Version element in the EPP RFCs. The version used in the RPP URL MUST match the version used in EPP Greeting message.

- `{collection}` MUST be substituted by "domains", "hosts" or
  "contacts" or other supported objects, referring to either [@!RFC5731], [@!RFC5732] or [@!RFC5733].

A trailing slash MAY be added to each request. Implementations MUST consider requests which only differ with respect to this trailing slash as identical.

A specific EPP object instance MUST be identified by {context-root}/ {version}/{collection}/{id} where {id} is a unique object identifier described in EPP RFCs.

An example domain name resource, for domain name example.nl, would look like this:

`/rpp/v1/domains/example.nl`

The path segment after a collection path segment MUST be used to identify an object instance, the path segment after an object instance MUST be used to identify attributes or related collections of the object instance.

<!--TODO ISSUE 7: No need for XML payload for GET requests when URL identifies object -->
Resource URLs used by RPP contain embedded object identifiers. By using an object identifier in the resource URL, the object identifier in the request messages becomes superfluous. However, since the goal of RPP is to maintain compatibility with existing EPP object mapping schemas, this redundancy is accepted as a tradeoff. Removing the object identifier from the request message would require updating the object mapping schemas in the EPP RFCs.

The server MUST return HTTP status code 412 when the object identifier, for example domain:name, host:name or contact:id, in the EPP request message does not match the {id} object identifier embedded in the URL.
  <!--TODO: is this not mixing epp and http status codes? -->

# Session Management

One of the main design considerations for RPP is to enable scalable EPP services, for this reason the RPP uses a stateless architecture and does not create and maintain client sessions. The Session concept is an anti-pattern in the context of a stateless service, the server MUST NOT maintain any state information relating to the client or EPP transaction.

Session management as described in [@!RFC5730] requires a stateful server architecture for maintaining client and application state over multiple client request and is therefore no longer supported.

A RPP request MUST contain all information required for the server to be able to successfully process the request. The client MUST include authentication credentials for each request. This MAY be done by using any of the available HTTP authentication mechanisms, such as those described in [@!RFC2617].

A RPP server MUST listen for HTTP connection requests on the standard TCP port assigned in [@!RFC2616]. After a connection has been established, the server MUST NOT return a Greeting message. The server MAY close open TCP connections when these violate server policies, for instance connections having a long inactivity period or a long connection lifetime. 

# REST {#rest}

RPP uses the REST architectural style, each HTTP method is assigned a distinct behavior, (#http-method) provides an overview of the behavior assigned to each method. RPP requests are expressed by a URL referring to a resource, a HTTP method, HTTP headers and an optional message body containing the EPP request message. 

<!--TODO ISSUE 10: allow for out of order processing -->
A RPP HTTP message body MUST contain at most a single EPP request or response. HTTP requests MUST be processed independently of each other and in the same order as received by the server. A client MAY choose to send a new request, using an existing connection, before the response for the previous request has been received (pipelining). A server using HTTP/2 [@!RFC7540] or HTTP/3 [@!RFC9114] contains built-in support for stream multiplexing and MAY choose to support pipelining using this mechanism. The response MAY be returned out of order back to the client, because some requests require more processing time by the server.

HTTP/1 does not use persistent connections by default, the client MAY use the "Connection" header to request for the server not to close the existing connection, so it can be re-used for future requests. The server MAY choose not to honor this request.

## Method Definition {#http-method}

RPP commands MUST be executed by using an HTTP method on a resource identified by an URL. The server MUST support the following methods.

- GET: Request a representation of an object resource or a collection of resources
- PUT: Update an existing object resource
- PATCH: Partially update an existing object resource
- POST: Create a new object resource
- DELETE: Delete an existing object resource
- HEAD: Check for the existence of an object resource
- OPTIONS: Request a greeting

## Content negotiation 

  <!--TODO ISSUE 6:Allow for additional dataformat -->    
The server MAY choose to support multiple data format for EPP object representations, such as XML and JSON.
The client and server MUST support server-driven content negotiation and related HTTP headers for content negotiation, as described in [@!RFC2616, section 12.2].
  
The client MUST use the following HTTP headers:

- `Content-Type`: Used to indicate the media type for the content in the message body 
- `Accept`: Used to indicate the media type the server MUST use for the representation of objects, this MAY
           be a list of types and related weight factors, as described in [@!RFC2616, section 14.1]

The client MUST synchronize the value for the Content-Type and Accept headers, for example a client MUST NOT send an XML formatted request message to the server, while at the same time requesting a JSON formatted response message. The server MUST use the `Content-Type` HTTP header to indicate the media type used for the representation in the response message body. The server MUST return HTTP status code 406 (Not Acceptable) or 415 (Unsupported Media Type) when the client requests an unsupported media type.

## Request

In contrast to EPP over TCP [@!RFC5734], a RPP request does not always require a EPP request message. The information conveyed by the HTTP method, URL, and request headers may be sufficient for the server to be able to successfully processes a request for most commands. However, the client MUST include the request message in the HTTP request body when the server uses an EPP extension that requires additional XML elements or attributes to be present in the request message. 
All RPP HTTP headers listed below use the "RPP-" prefix, following the recommendations in [@!RFC6648].

- `RPP-Cltrid`:  The client transaction identifier is the equivalent of the `clTRID` element defined in [@!RFC5730] and MUST be used accordingly, when the HTTP message body does not contain an EPP request that includes a cltrid.

- `RPP-Svcs`: The namespace used by the client in the EPP request message, this is equivalent to the "svcs" element in the Login command defined in [@!RFC5730, section 2.9.1.1]. The client MUST use this header if the media type of the request or response message body content requires the server to know what namespaces to use. Such as is the case for XML-based request and response messages. The header value MAY contain multiple comma separated namespaces.
    <!--TODO issue #31: do we add all namespaces to this header, also for extensions or do we need another header for extension -->

- `RPP-Svcs-Ext`: The extension namespace used by the client in the EPP request message, this is equivalent to the "svcExtension" element in the Login command defined in [@!RFC5730, section 2.9.1.1]

- `RPP-AuthInfo`: The client MAY use this header for sending basic token-based authorization information, as described in [@!RFC5731, section 2.6] and [@!RFC5733, section 2.8]. If the authorization is linked to a contact object then the client MUST also include the RPP-Roid header.

- `RPP-Roid`: If the authorization info, is linked to a database object, the client MAY use this header for the Repository Object IDentifier (ROID), as described in [@!RFC5730, section 4.2].
  <!-- TODO issue #33 : use header for simple auth token -->

- `Accept-Language`:  This header is equivalent to the "lang" element of the EPP Login command. The server MUST support the use of HTTP Accept-Language header by clients. The client MAY issue a Hello request to discover the languages supported by the server. Multiple servers in a load-balanced environment SHOULD reply with consistent "lang" elements in the Greeting response. The value of the Accept-Language header MUST match 1 of the languages from the Greeting. When the server receives a request using an unsupported language, the server MUST respond using the default language configured for the server, as required in [@!RFC5730, section 2.9.1.1] 
 
- `Connection`: If the server uses HTTP/1.1 or lower, the CLIENT MAY choose to use this header to request the server to keep op the TCT-connection. The client MUST not use this header when the server uses HTTP/2 [@!RFC9113, section 8.2.2] or HTTP/3 [@!RFC9113, section 4.2]
  <!--TODO ISSUE 11: How to handle connections -->   

- `Accept-Encoding`: The client MAY choose to use the Accept-Encoding HTTP header to request the server to use compression for the response message body.

  <!--TODO ISSUE 4: also include authentication header here? -->

## Response

The server HTTP response contains a status code, headers, and MAY contain an EPP response message in the message body. HTTP headers are used to transmit additional data to the client and MAY be used to send EPP process related data to the client. HTTP headers used by RPP MUST use the "RPP-" prefix, the following response headers have been defined for RPP.

- `RPP-Svtrid`:  This header is the equivalent of the "svTRID" element defined in [@!RFC5730] and MUST be used accordingly when the RPP response does not contain an EPP response in the HTTP message body. If an HTTP message body with the EPP XML equivalent "svTRID" exists, both values MUST be consistent.

- `RPP-Cltrid`: This header is the equivalent of the "clTRID" element defined in [@!RFC5730] and MUST be used accordingly when the RPP response does not contain an EPP response in the HTTP message body. If the contents of the HTTP message body contains a "clTRID" value, then both values MUST be consistent.
  
- `RPP-Eppcode`: This header is the equivalent of the EPP result code defined in [@!RFC5730] and MUST be used accordingly. This header MUST be added to all responses, except for the Greeting, and MAY be used by the client for easy access to the EPP result code, without having to parse the content of the HTTP response message body.

- `RPP-Check-Avail`: An alternative for the "avail" attribute of the object:name element in an Object Check response and MUST be used accordingly. The server does not return a HTTP message body in response to a RPP Object Check request.   

- `RPP-Check-Reason`: An optional alternative for the "object:reason" element in an Object Check response and MUST be used accordingly.

- `RPP-Queue-Size`: Return the number of unacknowledged messages in the client message queue. The server MAY include this header in all RPP responses.
    <!--TODO ISSUE 40: return queue size for all results-->   

- `Cache-Control`:  The client MUST never cache results, the server MUST always return the value "No-Store" for this header, as described in [@!RFC7234, section 5.2.1.5].
   <!--TODO ISSUE 10: How to handle caching -->   

- `Content-Language`: The server MUST include this header in every response that contains an EPP message in the message body.

- `Content-Encoding`: The server MAY choose to compress the responses message body, using an   algorithm selected from the list of algorithms provided by the client using the Accept-Encoding request header.

RPP does not always return an EPP response message in the HTTP message body. The `Object Check` request for example may return an empty HTTP response body. When the server does not return an EPP message, it MUST return at least the RPP-Svtrid, RPP-Cltrid and RPP-Eppcode headers.

## Error Handling {#error-handling}

  <!--TODO: ISSUE #35: Mapping EPP code to HTTP status codes -->
RESTful Provisioning Protocol and HTTP protocol are both an application layer protocol, having their own status- and result codes. The endpoints described in (#command-mapping) MUST return HTTP status code 200 (OK) for successful requests when the EPP result code indicates a positive completion (1xxx) of the EPP command.

When an EPP command results in a negative completion result code (2xxx), the server MUST return the HTTP status code 422 (Unprocessable Content). A more detailed explanation of the EPP error MUST be included in the message body of the HTTP response, as described in [@!RFC9110], but only when this is permitted for the used HTTP method. Errors related to the HTTP protocol MUST result in the use of an appropriate HTTP status code by the HTTP server. An error or problem while processing one request MUST NOT result in the failure of other independent requests using the same connection.

The client MUST be able to use the best practices for RESTful applications and use the HTTP status code to determine if the EPP request was successfully processed. The client MAY use the well defined HTTP status code and RPP-Eppcode HTTP header for error handling logic, without having to parse the EPP result code in the message body. 

For example, a client sending an Object Transfer request for an Object already linked to an active transfer process, will result in an EPP result code 2106, the HTTP response contains a status code 422 and he value for the RPP-Eppcode HTTP header is set to 2106. The client MAY use the HTTP status code for checking if an EPP command failed and only parse the result message when additional information from the response message is required for handling the error.

# Command Mapping {#command-mapping}

EPP commands are mapped to RESTful Provisioning Protocol requests using four elements.

1. Resource defined by a URL
2. HTTP method to be used on the resource
3. EPP request message
4. EPP response message

(#tbl-cmd-mapping) lists a mapping for each EPP command to a RPP request, the subsequent sections provide details for each request. Resource URLs in the table are assumed to be using the prefix: "/{context-root}/{version}/". Some RPP endpoints do not require a request and/or response message, as is indicated by the table columns "Request" and "response". 

- `{c}`:  An abbreviation for {collection}: this MUST be substituted with
  "domains", "hosts", "contacts" or any other collection of objects.
- `{i}`:  An abbreviation for an object id, this MUST be substituted with the value of a domain name, hostname, contact-id or a message-id or any other defined object.
- `Optional`: A request message is only required when the server uses an EPP extension, which requires the use of XML elements and/or atributes that are not mapped to RPP.

{#tbl-cmd-mapping}
Command            | Method   | Resource                  | Request     | Response
-------------------|----------|---------------------------|-------------|-----------------
Hello              | OPTIONS  | /                         | No          | Yes
Login              | N/A      | N/A                       | N/A         | N/A
Logout             | N/A      | N/A                       | N/A         | N/A
Check              | HEAD     | /{c}/{i}                  | No          | No
Info               | GET      | /{c}/{i}                  | Optional    | Yes
Poll Request       | GET      | /messages                 | No          | Yes
Poll Ack           | DELETE   | /messages/{i}             | No          | Yes
Create             | POST     | /{c}                      | Yes         | Yes
Delete             | DELETE   | /{c}/{i}                  | Optional    | Yes
Renew              | POST     | /{c}/{i}/renewals         | Optional    | Yes
Transfer Request   | POST     | /{c}/{i}/transfers        | Optional    | Yes
Transfer Query     | GET      | /{c}/{i}/transfers/latest | Optional    | Yes
Transfer Cancel    | DELETE   | /{c}/{i}/transfers/latest | Optional    | Yes
Transfer Approve   | PUT      | /{c}/{i}/transfers/latest | Optional    | Yes
Transfer Reject    | DELETE   | /{c}/{i}/transfers/latest | Optional    | Yes
Update             | PATCH    | /{c}/{i}                  | Yes         | Yes
Extension [1]      | *        | /{c}/{i}/extension/*      | *           | *
Extension [2]      | *        | /extension/*              | *           | *
Table: Mapping of EPP Command to RPP Request

[1] This mapping is used for Object extensions based on the extension mechanism as defined in [RFC5730, section 2.7.2] 
[2] This mapping is used for Protocol extensions based on the extension mechanism as defined in [RFC5730, seciton 2.7.1] 

When there is a mismatch between a resource identifier in the HTTP message body and the resource identifier in the URL used for a request, then the server MUST return HTTP status code 400 (Bad Request). The examples, in the sections below, assume the server does not use any EPP extensions and therefore the client does not add any request message to the HTTP message body.  

## Hello

- Request: OPTIONS /
- Request message: None
- Response message: Greeting response

Due to the stateless nature of RPP, the server does not respond by sending a Greeting message when a connection is created, as described in [@!RFC5730, section 2]. The client MUST request a Greeting by using the Hello request as described in [@!RFC5730, section 2.3]. The server MUST respond by returning a Greeting response, as defined in [@!RFC5730, section 2.4].

The version value used in the Hello response MUST match the version value used for the `{version}` path segment in the URL used for the Hello request.

Example request:

```
C: OPTIONS /rpp/v1/ HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: Connection: keep-alive

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 799
S: Content-Type: application/epp+xml
S: Content-Language: en
S:
S: <?xml version="1.0" encoding="UTF-8" standalone="no"?>
S: <rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
S:   <greeting>
S:      <svcMenu>
S:         <version>1.0</version>
S:         <!-- The rest of the response is omitted here -->
S:      <svcMenu>
S:   </greeting>
S: </rpp>
```

##  Login

The Login command defined in [@!RFC5730, section 2.9.1.1] is used to establish a session between client and server, this is part of the stateful nature of the EPP protocol. RPP is stateless and MUST NOT maintain any client state and does not include a Login command. The client MUST include all information in a RPP request, required for the server to be able to properly process the request. This includes request attributes defined as for Login command in [@!RFC5730, section 2.9.1.1].

  <!--TODO ISSUE #16: do we support changing password using /password  -->
The request attributes from the Login command, used for configuring the client session, are moved to the HTTP layer.

- `clID`: Replaced by HTTP authentication
- `pw:`: Replaced by HTTP authentication
- `newPW`: Replaced by out of band process
- `version`: Replaced by the `{version}` path parameter in the request URL.
- `lang`: Replaced by the `Accept-Language` HTTP header.
- `svcs`: Replaced by the `RPP-Svcs` HTTP header.
- `svcExtension`:  Replaced by the `RPP-Svcs-Ext` HTTP header.

The server MUST check the namespaces used in the RPP-Svcs HTTP header. An unsupported namespace MUST result in the appropriate EPP result code.

##  Logout

Due to the stateless nature of RPP, the session concept is no longer used and therefore the Logout command MUST NOT be implemented by the server.

## Query Resources

   <!--TODO: ISSUE #9: How to handle authInfo data for INFO command (GET request)? -->
A RPP client MAY use the HTTP GET method for executing a query command only when no request data has to be added to the HTTP message body. Sending content using an HTTP GET request is discouraged in [@!RFC9110], there exists no generally defined semantics for content received in a GET request. When an EPP object requires additional authInfo information, as described in [@!RFC5731] and [@!RFC5733], the client MUST use the HTTP POST method and add the query command content to the HTTP message body.

### Check

- Request: HEAD /{collection}/{id}
- Request message: None
- Response message: None

 The HTTP HEAD method MUST be used for object existence check. The response MUST contain the `RPP-Check-Avail` header and MAY contain the `RPP-Check-Reason` header. The value of the `RPP-Check-Avail` header MUST be "0" or "1" as described in [@!RFC5730, section 2.9.2.1], depending on whether the object can be provisioned or not. 

The Check endpoint MUST be limited to checking only a single object-id per request. This may seem a limitation compared to the Check command defined in [@!RFC5730] where a Check message may contain multiple object-ids. The RPP Check request can be load balanced more efficiently when only a single object-id has to be checked. 

Example request for a domain name:

```
C: HEAD /rpp/v1/domains/example.nl HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```
Example response:

```
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: RPP-Cltrid: ABC-12345
S: RPP-Svtrid: XYZ-12345
S: RPP-Check-Avail: 0
S: RPP-Check-Reason: In use
S: RPP-result-code: 1000
s: Content-Length: 0

```

### Info

The Object Info request MUST use the HTTP GET method on a resource identifying an object instance, using an empty message body. If the object has authorization information attached and the authorization then the client MUST include the RPP-AuthInfo HTTP header. If the authorization is linked to a database object the client MUST include the RPP-Roid header.

Example request for an object not using authorization information.  

- Request: GET /{collection}/{id}
- Request message: Optional
- Response message: Info response

```
C: GET /rpp/v1/domains/example.nl HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

Example request using RPP-AuthInfo header for an object that has attached authorization information.  

- Request: GET /{collection}/{id}
- Request message: Optional
- Response message: Info response

```
C: GET /rpp/v1/domains/example.nl HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: RPP-AuthInfo: secret-token
C: RPP-Roid: REG-XYZ-12345
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

Example Info response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 424
S: Content-Type: application/epp+xml
S: Content-Language: en
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
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
S:</rpp>
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
C: GET /rpp/v1/domains/example.nl?filter=hosts&val=del HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

### Poll

#### Poll Request

- Request: GET /messages
- Request message: None
- Response message: Poll response

The client MUST use the HTTP GET method on the messages resource collection to request the message at the head of the queue. The "op=req" semantics from [@!RFC5730, Section 2.9.2.3] are assigned to the HTTP GET method.

Example request:

```
C: GET /rpp/v1/messages HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345

```
Example response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 312
S: Content-Type: application/epp+xml
S: Content-Language: en
S: RPP-Eppcode: 1301
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
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
S:</rpp>
```

#### Poll Ack

- Request: DELETE /messages/{id}
- Request message: None
- Response message: Poll Ack response

The client MUST use the HTTP DELETE method to acknowledge receipt of a message from the queue. The "op=ack" semantics from [@!RFC5730, Section 2.9.2.3] are assigned to the HTTP DELETE method. The "msgID" attribute of a received EPP Poll message MUST be included in the message resource URL, using the {id} path element. The server MUST use RPP headers to return the EPP result code and the number of messages left in the queue. The server MUST NOT add content to the HTTP message body of a successful response, the server may add content to the message body of an error response. 

Example request:

```
C: DELETE /rpp/v1/messages/12345 HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345

```
Example response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Language: en
S: RPP-Eppcode: 1000
S: RPP-Queue-Size: 0
S: RPP-Svtrid: XYZ-12345
S: RPP-Cltrid: ABC-12345
S: Content-Length: 145
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
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
S:</rpp>
```

### Transfer Query

The Transfer Query request MUST use the special "latest" sub-resource to refer to the
latest object transfer. A latest transfer object may not exist, when no transfer has been initiated for the specified object.
The "op=query" semantics from [@!RFC5730, Section 2.9.3.4] are assigned to the HTTP GET method. The client MUST use the HTTP GET method and MUST NOT add content to the HTTP message body.

- Request: GET {collection}/{id}/transfers/latest
- Request message: Optional
- Response message: Transfer Query response

Example domain name Transfer Query request without authorization information required:

```
C: GET /rpp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

If the requested object has associated authorization information that is not linked to another database object, then the HTTP GET method MUST be used and the authorization information MUST be included using the RPP-AuthInfo header.

Example domain name Transfer Query request using RPP-AuthInfo header:

```
C: GET /rpp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: RPP-AuthInfo: secret-token
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0

```

If the requested object has associated authorization information linked to another database object, then the HTTP GET method MUST be used and both the RPP-AuthInfo and the RPP-Roid header MUST be included. 

Example domain name Transfer Query request and authorization using RPP-AuthInfo and the RPP-Roid header:

```
C: GET /rpp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-AuthInfo: secret-token
C: RPP-Roid: REG-XYZ-12345
C: Content-Length: 0
C:

```

Example Transfer Query response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 230
S: Content-Type: application/epp+xml
S: Content-Language: en
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
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
S:</rpp>
```

## Transform Resources

### Create

- Request: POST /{collection}
- Request message: Object Create request
- Response message: Object Create response

The client MUST use the HTTP POST method to create a new object resource. If the EPP request results in a newly created object, then the server MUST return HTTP status code 200 (OK). The server MUST add the "Location" header to the response, the value of this header MUST be the URL for the newly created resource.

Example Domain Create request:

```xml
C: POST /rpp/v1/domains HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 220
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
C:  <request>
C:    <body>
C:      <domain:create
C:       xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
C:        <domain:name>example.nl</domain:name>
C:        <!-- The rest of the request is omitted here -->
C:      </domain:create>
C:    </body>
C:    <clTRID>ABC-12345</clTRID>
C:  </request>
C:</rpp>
```

Example Domain Create response:

```xml
S: HTTP/2 200
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Language: en
S: Content-Length: 642
S: Content-Type: application/epp+xml
S: Location: https://rpp.example.nl/rpp/v1/domains/example.nl
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0"
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
S:         <svTRID>XYZ-12345</svTRID>
S:      </trID>
S:   </response>
S:</rpp>
```

### Delete

- Request: DELETE /{collection}/{id} 
- Request message: Optional
- Response message: Status

The client MUST the HTTP DELETE method and a resource identifying a unique object instance. The server MUST return HTTP status code 200 (OK) if the resource was deleted successfully.

Example Domain Delete request:

```
C: DELETE /rpp/v1/domains/example.nl HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345

```

Example Domain Delete response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 80
S: RPP-Svtrid: XYZ-12345
S: RPP-Cltrid: ABC-12345
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</rpp>
```

### Renew

- Request: POST /{collection}/{id}/renewals
- Request message: Optional
- Response message: Renew response

The Renew command is mapped to a nested collection, named "renewals". Not all EPP object types include support for the renew command. The current-date query parameter MAY be used for date on which the current validity period ends, as described in [@!RFC5731, section 3.2.3]. The new period MAY be added to the request using the unit and value request parameters. The response MUST include the Location header for the renewed object.

Example Domain Renew request:

```
C: POST /rpp/v1/domains/example.nl/renewals?current-date=2024-01-01 HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 0
C: 
```

Example Domain Renew request, using 1 year period:

```
C: POST /rpp/v1/domains/example.nl/renewals?current-date=2024-01-01?unit=y&value=1 HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 0
C: 
```

Example Renew response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Language: en
S: Content-Length: 205
S: Location: https://rpp.example.nl/rpp/v1/domains/example.nl
S: Content-Type: application/epp+xml
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
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
S:</rpp>
```

### Transfer

Transferring an object from one sponsoring client to another client is specified in [@!RFC5731] and [@!RFC5733]. The Transfer command is mapped to a nested resource, named "transfers". The semantics of the HTTP DELETE method are determined by the role of the client executing the DELETE method. The DELETE method is defined as "reject transfer" for the current sponsoring client of the object. For the new sponsoring client the DELETE method is defined as "cancel transfer".

#### Request

- Request: POST /{collection}/{id}/transfers
- Request message: Optional
- Response message: Status

The "op=request" semantics from [@!RFC5730, Section 2.9.3.4] are assigned to the HTTP POST method.
In order to initiate a new object transfer process, the client MUST use the HTTP POST method on a unique resource to create a new transfer resource object. Not all EPP objects support the Transfer command as described in [@!RFC5730, section 3.2.4], [@!RFC5731, section 3.2.4] and [@!RFC5733, section 3.2.4].

If the transfer request is successful, then the response MUST include the Location header for the object being transferred.

Example request not using object authorization:

```
C: POST /rpp/v1/domains/example.nl/transfers HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: Content-Length: 0

```

Example request using object authorization:

```xml
C: POST /rpp/v1/domains/example.nl/transfers HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: RPP-Cltrid: ABC-12345
C: RPP-AuthInfo: secret-token
C: Accept-Language: en
C: Content-Length: 0

```

Example request using 1 year renewal period, using the `unit` and `value` query parameters:

```
C: POST /rpp/v1/domains/example.nl/transfers?unit=y&value=1 HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: Content-Length: 0

```

<!--
Example request using object authorization linked to a contact object:

```xml
C: POST /rpp/v1/domains/example.nl/transfers HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Accept-Language: en
C: Content-Length: 252
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
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
C:</rpp>
```
-->

Example Transfer response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Language: en
S: Content-Length: 328
S: Content-Type: application/epp+xml
S: Location: https://rpp.example.nl/rpp/v1/domains/example.nl/transfers/latest
S: RPP-Eppcode: 1001
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
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
S:</rpp>
```


#### Cancel

- Request: DELETE /{collection}/{id}/transfers/latest
- Request message: Optional
- Response message: Status

The "op=cancel" semantics from [@!RFC5730, Section 2.9.3.4] are assigned to the HTTP DELETE method.
The new sponsoring client MUST use the HTTP DELETE method to cancel a requested transfer. 

Example request:

```
C: DELETE /rpp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 80
S: RPP-Svtrid: XYZ-12345
S: RPP-Cltrid: ABC-12345
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</rpp>
```

#### Reject

- Request: DELETE /{collection}/{id}/transfers/latest
- Request message:  None
- Response message: Status

The "op=reject" semantics from [@!RFC5730, Section 2.9.3.4] are assigned to the HTTP DELETE method.
The currently sponsoring client of the object MUST use the HTTP DELETE method to reject a started transfer process.

Example request:

```
C: DELETE /rpp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345

```

Example Reject response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 80
S: RPP-Svtrid: XYZ-12345
S: RPP-Cltrid: ABC-12345
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</rpp>

```

#### Approve

- Request: PUT /{collection}/{id}/transfers/latest
- Request message: Optional
- Response message: Status

The "op=approve" semantics from [@!RFC5730, Section 2.9.3.4] are assigned to the HTTP PUT method.
The currently sponsoring client MUST use the HTTP PUT method to approve a transfer requested by the new sponsoring client.

Example Approve request:

```
C: PUT /rpp/v1/domains/example.nl/transfers/latest HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Cltrid: ABC-12345
C: Content-Length: 0

```

Example Approve response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 80
S: RPP-Svtrid: XYZ-12345
S: RPP-Cltrid: ABC-12345
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</rpp>
```

### Update

- Request: PATCH /{collection}/{id}
- Request message: Object Update message
- Response message: Status

An object Update request MUST be performed using the HTTP PATCH method. The request message body MUST contain an EPP Update request, and the object-id value in the request MUST match the value of the object-id path parameter in the URL.

Example request:

```xml
C: PATCH /rpp/v1/domains/example.nl HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Content-Type: application/epp+xml
C: Accept-Language: en
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: Content-Length: 252
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
C:  <request>
C:    <body>
C:      <domain:update
C:       xmlns:domain="urn:ietf:params:xml:ns:domain-1.0">
C:        <domain:name>example.nl</domain:name>
C:           <!-- The rest of the request is omitted here -->
C:      </domain:update>
C:    </body>
C:    <clTRID>ABC-12345</clTRID>
C:  </request>
C:</rpp>
```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Length: 80
S: RPP-Svtrid: XYZ-12345
S: RPP-Cltrid: ABC-12345
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</rpp>
```

## Extension Framework

The EPP Extension Framework allows for extending the EPP protocol at different locations, RPP defines additional REST resources for the Protocol and Command-Response extensions.

### Protocol Extension

- Request: * /extensions/*
- Request message: *
- Response message: *

EPP Protocol extensions, defined in [@!RFC5730, section 2.7.1] are supported using the "/extensions" root resource.
The HTTP method used for a new Protocol extension is not defined but must follow the RESTful principles.

The example below, illustrates the use of the "Domain Cancel Delete" command as defined as a custom command in [@?SIDN-EXT]. The new command is created below the "extensions" path element and after this element follows the "domains" object collection, finally a special "deletion" path element is added to the end of the URL. A client MUST use the HTPP DELETE method on a domain name deletion resource to cancel an ongoing domain delete transaction and move the domain from the grace state back to the active state.

Example Protocol Extension request:

- Request: DELETE /extensions/{collection}/{id}/deletion
- Request message: Optional
- Response message: Optional error response

```
C: DELETE /rpp/v1/extensions/domains/example.nl/deletion HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Svcs: urn:ietf:params:xml:ns:domain-1.0
C: RPP-Svcs-Ext: https://rxsd.domain-registry.nl/sidn-ext-epp-1.0
C: RPP-Cltrid: ABC-12345

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Language: en
S: Content-Length: 0
S: RPP-Svtrid: XYZ-12345
S: RPP-Cltrid: ABC-12345
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
S:  <response>
S:    <result code="1000">
S:      <msg>Command completed successfully</msg>
S:    </result>
S:    <trID>
S:      <clTRID>ABC-12345</clTRID>
S:      <svTRID>XYZ-12345</svTRID>
S:    </trID>
S:  </response>
S:</rpp>
```

### Object Extension

An Object extension is differs from the other 2 extension types in the way that an Object extension is implemented using a new Object mapping for a new Object type, while re-using the existing EPP command and response structures. The newly created Object mapping, is similar to the existing Object mappings defined in [@!RFC5731], [@!RFC5732] and [@!RFC5733], and MUST be used in a similar fashion.

A hypothetical new Object mapping for IP addresses, may result in a new resource collection named "ips", the semantics for the HTTP methods would have to be defined. Creating a new IP address may use the HTTP POST method on the "ips" collection.

- Request: POST /{collection}/{id}
- Request message: IP Create Request message
- Response message: IP Create Response message

Example request:

```xml
C: POST /rpp/v1/ips HTTP/2
C: Host: rpp.example.nl
C: Authorization: Bearer <token>
C: Accept: application/epp+xml
C: Accept-Language: en
C: RPP-Svcs-Ext: https://example.nl/epp-ips-1.0
C: RPP-Cltrid: ABC-12345
C: Content-Type: application/epp+xml
C: Content-Length: 220
C:
C:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
C:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0">
C:  <request>
C:    <body>
C:      <ip:create
C:       xmlns:ip="https://example.nl/epp-ip-1.0">
C:        <ip:address>192.0.2.1</ip:address>
C:        <!-- The rest of the request is omitted here -->
C:      </ip:create>
C:    </body>
C:    <clTRID>ABC-12345</clTRID>
C:  </request>
C:</rpp>

```

Example response:

```xml
S: HTTP/2 200 OK
S: Date: Wed, 24 Jan 2024 12:00:00 UTC
S: Server: Example RPP server v1.0
S: Content-Language: en
S: Content-Length: 642
S: Content-Type: application/epp+xml
S: Location: https://rpp.example.nl/rpp/v1/ips/192.0.2.1
S: RPP-Eppcode: 1000
S:
S:<?xml version="1.0" encoding="UTF-8" standalone="no"?>
S:<rpp xmlns="urn:ietf:params:xml:ns:rpp-1.0"
S:     xmlns:ip="https://example.nl/epp-ip-1.0">
S:   <response>
S:      <result code="1000">
S:         <msg>Command completed successfully</msg>
S:      </result>
S:      <resData>
S:         <ip:creData>
S:            <!-- The rest of the response is omitted here -->
S:         </ip:creData>
S:      </resData>
S:      <trID>
S:         <clTRID>ABC-12345</clTRID>
S:         <svTRID>XYZ-12345</svTRID>
S:      </trID>
S:   </response>
S:</rpp>

```
 
### Command-Response Extension

Command-Response Extensions allow for adding elements to an existing object mapping, therefore no new extension resource is required, the existing resources can be used for existing and future extensions of this type.  

# Protocol Considerations

  <!--TODO ISSUE #2: not all considerations are met by rpp? -->
  <!--TODO ISSUE #36: create update for this section in rfc5730 -->

[@!RFC5730, section 2.1] of the EPP protocol specification describes considerations to be addressed by a transport or protocol mapping. These are satisfied by a combination of RPP features and features provided by HTTP protocol and underlying transport protocols, as described below.

- The consideration: "The transport mapping MUST preserve the stateful nature of the protocol", is updated to: "The transport mapping MUST preserve the stateful nature of the protocol, when using a stateful transport protocol". RPP uses the REST architectural style for defining a stateless API based on the stateless HTTP protocol, and therefore satisfies the updated consideration. 

- (#rest) describes how HTTP multiplexing may be used for pipelining multiple requests. A server may allow pipelining, requests are to be processed in the order they have been received.

- RPP is based on the HTTP protocol, which uses the client-server model.
- RPP messages are transmitted using HTTP, this document refers to the HTTP [@!RFC2616] protocol specification for how data units are framed.
- HTTP/1 and HTTP/2 use TCP as a transport protocol and this includes features to provide reliability, flow control, ordered delivery, and congestion control [@!RFC793, section 1.5] describes these features in detail; congestion control principles are described further in [@!RFC2581] and [@!RFC2914]. HTTP/3 uses QUIC (UDP) as a transport protocol, which has built-in congestion control over UDP.

- (#rest) describes how requests are processed independently of each other.
- Errors while processing a RPP request are isolated to this request and do not affect other requests sent by the client or other clients, this is described in (#error-handling).

-  Batch-oriented processing (combining multiple EPP commands in a single HTTP request) is not permitted. To maximize scalability
   every request must contain a single command, as described in (#rest).

# Formal Syntax {#formal-syntax}

This section contains the XML Schema notation defined for RPP, based on the XML schema defined in [@!RFC5730].
The XML schema defined in [@!RFC5730] contains XML elements and attributes that are no longer required in a RPP context.

The following changes have been made:

- deleted hello from eppType
- renamed command to request in eppType
- deleted choice and all child elements from commandtype 
- renamed commandtype to requestType
- renamed readWriteType to bodyType
- created body element for requestType
- deleted loginType
- deleted credsOptionsType
- deleted loginSvcType
- deleted pwType
- deleted pollType
- deleted transferType
- deleted transferOpType

The formal syntax presented here is a complete schema representation of RPP suitable for automated validation of RPP XML instances.


```xml
<?xml version="1.0" encoding="UTF-8"?>

<schema targetNamespace="urn:ietf:params:xml:ns:rpp-1.0"
xmlns:rpp="urn:ietf:params:xml:ns:rpp-1.0"
xmlns:eppcom="urn:ietf:params:xml:ns:eppcom-1.0"
xmlns="http://www.w3.org/2001/XMLSchema"
elementFormDefault="qualified">

   <!--
   Import common element types.
   -->
     <import namespace="urn:ietf:params:xml:ns:eppcom-1.0"/>

     <annotation>
       <documentation>
         RESTful Extensible Provisioning Protocol v1.0 schema.
       </documentation>
     </annotation>

   <!--
   Every EPP XML instance must begin with this element.
   -->

   <element name="rpp" type="rpp:eppType"/>

   <!--
   An EPP XML instance must contain a greeting, request, response, or extension.
   -->
     <complexType name="eppType">
       <choice>
         <element name="greeting" type="rpp:greetingType"/>
         <element name="request" type="rpp:requestType"/>
         <element name="response" type="rpp:responseType"/>
         <element name="extension" type="rpp:extAnyType"/>
       </choice>
     </complexType>

   <!--
   A greeting is sent by a server in response to a client connection
   or <hello>.
   -->
     <complexType name="greetingType">
       <sequence>
         <element name="svID" type="rpp:sIDType"/>
         <element name="svDate" type="dateTime"/>
         <element name="svcMenu" type="rpp:svcMenuType"/>
         <element name="dcp" type="rpp:dcpType"/>
       </sequence>
     </complexType>

   <!--
   Server IDs are strings with minimum and maximum length restrictions.
   -->
     <simpleType name="sIDType">
       <restriction base="normalizedString">
         <minLength value="3"/>
         <maxLength value="64"/>
       </restriction>
     </simpleType>

   <!--
   A server greeting identifies available object services.
   -->
     <complexType name="svcMenuType">
       <sequence>
         <element name="version" type="rpp:versionType"
          maxOccurs="unbounded"/>
         <element name="lang" type="language"
          maxOccurs="unbounded"/>
         <element name="objURI" type="anyURI"
          maxOccurs="unbounded"/>
         <element name="svcExtension" type="rpp:extURIType"
          minOccurs="0"/>
       </sequence>
     </complexType>

   <!--
   Data Collection Policy types.
   -->
     <complexType name="dcpType">
       <sequence>
         <element name="access" type="rpp:dcpAccessType"/>
         <element name="statement" type="rpp:dcpStatementType"
          maxOccurs="unbounded"/>
         <element name="expiry" type="rpp:dcpExpiryType"
          minOccurs="0"/>
       </sequence>
     </complexType>

     <complexType name="dcpAccessType">
       <choice>
         <element name="all"/>
         <element name="none"/>
         <element name="null"/>
         <element name="other"/>
         <element name="personal"/>
         <element name="personalAndOther"/>
       </choice>
     </complexType>

     <complexType name="dcpStatementType">
       <sequence>
         <element name="purpose" type="rpp:dcpPurposeType"/>
         <element name="recipient" type="rpp:dcpRecipientType"/>
         <element name="retention" type="rpp:dcpRetentionType"/>
       </sequence>
     </complexType>

     <complexType name="dcpPurposeType">
       <sequence>
         <element name="admin"
          minOccurs="0"/>
         <element name="contact"
          minOccurs="0"/>
         <element name="other"
          minOccurs="0"/>
         <element name="prov"
          minOccurs="0"/>
       </sequence>
     </complexType>

     <complexType name="dcpRecipientType">
       <sequence>
         <element name="other"
          minOccurs="0"/>
         <element name="ours" type="rpp:dcpOursType"
          minOccurs="0" maxOccurs="unbounded"/>
         <element name="public"
          minOccurs="0"/>
         <element name="same"
          minOccurs="0"/>
         <element name="unrelated"
          minOccurs="0"/>
       </sequence>
     </complexType>

     <complexType name="dcpOursType">
       <sequence>
         <element name="recDesc" type="rpp:dcpRecDescType"
          minOccurs="0"/>
       </sequence>
     </complexType>

     <simpleType name="dcpRecDescType">
       <restriction base="token">
         <minLength value="1"/>
         <maxLength value="255"/>
       </restriction>
     </simpleType>

     <complexType name="dcpRetentionType">
       <choice>
         <element name="business"/>
         <element name="indefinite"/>
         <element name="legal"/>
         <element name="none"/>
         <element name="stated"/>
       </choice>
     </complexType>

     <complexType name="dcpExpiryType">
       <choice>
         <element name="absolute" type="dateTime"/>
         <element name="relative" type="duration"/>
       </choice>
     </complexType>

   <!--
   Extension framework types.
   -->
     <complexType name="extAnyType">
       <sequence>
         <any namespace="##other"
          maxOccurs="unbounded"/>
       </sequence>
     </complexType>

     <complexType name="extURIType">
       <sequence>
         <element name="extURI" type="anyURI"
          maxOccurs="unbounded"/>
       </sequence>
     </complexType>

   <!--
   An EPP version number is a dotted pair of decimal numbers.
   -->
     <simpleType name="versionType">
       <restriction base="token">
         <pattern value="[1-9]+\.[0-9]+"/>
         <enumeration value="1.0"/>
       </restriction>
     </simpleType>

   <!--
   Request type, reduced to a single <body> element for object-data.
   -->

<complexType name="requestType">
  <sequence>
    <element name="body" type="rpp:bodyType"/>
    <element name="extension" type="rpp:extAnyType"
     minOccurs="0"/>
    <element name="clTRID" type="rpp:trIDStringType"
     minOccurs="0"/>
  </sequence>
</complexType>

 
   <!--
     All other object-centric request bodies. EPP doesn't specify the syntax or
     semantics of object-centric body elements.
     The elements MUST be described in detail in another schema specific to the object.
   -->
     <complexType name="bodyType">
       <sequence>
         <any namespace="##other"/>
       </sequence>
     </complexType>

     <complexType name="trIDType">
       <sequence>
         <element name="clTRID" type="rpp:trIDStringType"
          minOccurs="0"/>
         <element name="svTRID" type="rpp:trIDStringType"/>
       </sequence>
     </complexType>

     <simpleType name="trIDStringType">
       <restriction base="token">
         <minLength value="3"/>
         <maxLength value="64"/>
       </restriction>
     </simpleType>

   <!--
   Response types.
   -->
     <complexType name="responseType">
       <sequence>
         <element name="result" type="rpp:resultType"
          maxOccurs="unbounded"/>
         <element name="msgQ" type="rpp:msgQType"
          minOccurs="0"/>

         <element name="resData" type="rpp:extAnyType"
          minOccurs="0"/>
         <element name="extension" type="rpp:extAnyType"
          minOccurs="0"/>
         <element name="trID" type="rpp:trIDType"/>
       </sequence>
     </complexType>

     <complexType name="resultType">
       <sequence>
         <element name="msg" type="rpp:msgType"/>
         <choice minOccurs="0" maxOccurs="unbounded">
           <element name="value" type="rpp:errValueType"/>
           <element name="extValue" type="rpp:extErrValueType"/>
         </choice>
       </sequence>
       <attribute name="code" type="rpp:resultCodeType"
        use="required"/>
     </complexType>

     <complexType name="errValueType" mixed="true">
       <sequence>
         <any namespace="##any" processContents="skip"/>
       </sequence>
       <anyAttribute namespace="##any" processContents="skip"/>
     </complexType>

     <complexType name="extErrValueType">
       <sequence>
         <element name="value" type="rpp:errValueType"/>
         <element name="reason" type="rpp:msgType"/>
       </sequence>
     </complexType>

     <complexType name="msgQType">
       <sequence>
         <element name="qDate" type="dateTime"
          minOccurs="0"/>
         <element name="msg" type="rpp:mixedMsgType"
          minOccurs="0"/>
       </sequence>
       <attribute name="count" type="unsignedLong"
        use="required"/>
       <attribute name="id" type="eppcom:minTokenType"
        use="required"/>
     </complexType>

     <complexType name="mixedMsgType" mixed="true">
       <sequence>
         <any processContents="skip"
          minOccurs="0" maxOccurs="unbounded"/>
       </sequence>
       <attribute name="lang" type="language"
        default="en"/>
     </complexType>

   <!--
   Human-readable text may be expressed in languages other than English.
   -->
     <complexType name="msgType">
       <simpleContent>
         <extension base="normalizedString">
           <attribute name="lang" type="language"
            default="en"/>
         </extension>
       </simpleContent>
     </complexType>

   <!--
   EPP result codes.
   -->
     <simpleType name="resultCodeType">
       <restriction base="unsignedShort">
         <enumeration value="1000"/>
         <enumeration value="1001"/>
         <enumeration value="1300"/>
         <enumeration value="1301"/>
         <enumeration value="1500"/>
         <enumeration value="2000"/>
         <enumeration value="2001"/>
         <enumeration value="2002"/>
         <enumeration value="2003"/>
         <enumeration value="2004"/>
         <enumeration value="2005"/>
         <enumeration value="2100"/>
         <enumeration value="2101"/>
         <enumeration value="2102"/>
         <enumeration value="2103"/>
         <enumeration value="2104"/>
         <enumeration value="2105"/>
         <enumeration value="2106"/>
         <enumeration value="2200"/>
         <enumeration value="2201"/>
         <enumeration value="2202"/>
         <enumeration value="2300"/>
         <enumeration value="2301"/>
         <enumeration value="2302"/>
         <enumeration value="2303"/>
         <enumeration value="2304"/>
         <enumeration value="2305"/>
         <enumeration value="2306"/>
         <enumeration value="2307"/>
         <enumeration value="2308"/>
         <enumeration value="2400"/>
         <enumeration value="2500"/>
         <enumeration value="2501"/>
         <enumeration value="2502"/>
       </restriction>
     </simpleType>

   <!--
   End of schema.
   -->
   </schema>
```

# IANA Considerations

The URNs used in this document for XML namespaces and XML schemas have been registered by the IANA as described by [@!RFC3688].

Registration request for the RPP namespace:

- URI: urn:ietf:params:xml:ns:rpp-1.0
- Registrant Contact: See the "Author's Address" section of this document.
- XML: None.  Namespace URIs do not represent an XML specification.

Registration request for the EPP XML schema:

- URI: urn:ietf:params:xml:schema:rpp-1.0
- Registrant Contact: See the "Author's Address" section of this document.
- XML: See the (#formal-syntax) section of this document.


# Internationalization Considerations

[TBD: any? Accept-Language in HTTP Header]

# Security Considerations

Running RPP relies on the security of the underlying HTTP [@!RFC9110] transport, hence the best common practices for securing HTTP also apply to RPP. It is RECOMMENDED to follow them closely.

Data confidentiality and integrity MUST be enforced, all data transport between a client and server MUST be encrypted using TLS [@!RFC5246]. [@!RFC5734, Section 9] describes the level of security that is REQUIRED for all RPP endpoints.

The EPP Login command, described by [@!RFC5730], for creating a client session MUST NOT be used anymore. Due to the stateless nature of RPP, the client MUST include the authentication credentials in each HTTP request. This MAY be done by using JSON Web Tokens (JWT) [@!RFC7519] or Basic authentication [@!RFC7617].

The management of authentication credentials, such as the "Change password" functionality of the EPP Login command, MUST be performed by an out-of-band process. RPP (HTTP) servers are vulnerable to common denial-of-service attacks. Therefore, the security considerations of [@!RFC5734] also apply to RPP.


# Obsolete EPP Result Codes

The following EPP result codes specified in [@!RFC5730] are no longer
meaningful in the context of RESTful Provisioning Protocol and MUST NOT be used.

| Code | Reason                                                     
------|------------------------------------------------------------
| 1500 | Authentication functionality is delegated to the HTTP protocol layer                
| 2100 | The RPP URL includes a path segment for the version
| 2200 | Authentication functionality is delegated to the HTTP protocol layer           
| 2501 | Authentication functionality is delegated to the HTTP protocol layer 
| 2502 | Rate limiting functionality is delegated to the HTTP protocol layer    
Table: Obsolete EPP result codes

# Overview of EPP modifications

This section lists a non-exhaustive overview of the most important modifications made in RESTful Provisioning Protocol, compared to the EPP RFCs.

- The use of HTTP as an additional application layer protocol.
- HTTP adds additional status codes.
- Some Commands are no longer used, such as the Login and Logout command.
- No client sessions, every request needs to include authentication credentials.
- A command MUST only contain a single object to operate on, the check command. For example, the Check command only supports 1 object per request.
- Request messages may no longer be required for most commands
- Authentication and authorizations have become an out-of-band process.
- Support for additional data formats such as JSON.


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
