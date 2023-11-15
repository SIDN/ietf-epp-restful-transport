%%%
title = "Extensible Provisioning Protocol (EPP) RESTful Transport"
abbrev = "RESTful Transport for EPP"
ipr = "trust200902"
area = "Internet"
workgroup = "Network Working Group"
submissiontype = "IETF"
keyword = [""]

[seriesInfo]
name = "Internet-Draft"
value = "draft-epp-restful-transport-latest"
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

[[author]]
initials="M."
surname="Davids"
fullname="Marco Davids"
abbrev = ""
organization = "SIDN Labs"
  [author.address]
  email = "marco.davids@sidn.nl"
%%%

.# Abstract

This document specifies a 'RESTful transport for EPP' (REPP) with the
aim to improve efficiency and interoperability of EPP.

This document includes a new EPP Protocol Extension as well as a
mapping of [@!RFC5730] XML-commands to an HTTP based (RESTful)
interface.  Existing semantics and mappings as defined in [@!RFC5731],
[@!RFC5732] and [@!RFC5733] are largely retained and reusable in RESTful
EPP.

With REPP, no session is created on the EPP server.  Each request
from client to server will contain all of the information necessary
to understand the request.  The server will close the connection
after each HTTP request.

{mainmatter}

# Introduction

This document describes a new transport protocol for EPP, based on the [@!REST] architectural style.
The newly defined transport leverages the HTTP protocol [@!RFC2616]
and the principles of [@!REST].
Conforming to the REST constraints is generally referred to as being "RESTful".
Hence we dubbed the new transport protocol: "'RESTful transport for EPP" or "REPP"
for short.

This new transport machanism includes an new EPP Protocol Extension and a mapping of
[@!RFC5730] XML-commands to [URI] resources. REPP, in contrast to
the EPP specification, is stateless.  It aims to provide a
mechanism that is more suitable for complex, high availability
environments, as well as for environments where TCP connections can
be unreliable.

RFC 5730 [@!RFC5730] Section 2.1 describes that EPP can be layered over
multiple transport protocols.  Currently, the EPP transport over TCP
[@!RFC5734] is the only widely deployed transport mapping for EPP.
This same section defines that newly defined transport mappings must
preserve the stateful nature of EPP.

The stateless nature of REPP dictates that no session state is maintained on the EPP server.  Each request
from client to server will contain all of the information necessary
to understand the request.  The server will close the connection
after each HTTP request.

With a stateless mechanism, some drawbacks of EPP (as mentioned in
Section 5) are circumvented.

A good understanding of the EPP base protocol specification [@!RFC5730]
is advised, to grasp the extension and command mapping described in this
document.

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
"SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
document are to be interpreted as described in [@!RFC2119].

# Terminology

In this document the following terminology is used.

REST - Representational State Transfer ([@!REST]). An architectural
style.

RESTful - A RESTful web service is a web service or API implemented using
HTTP and the principles of [@!REST].

EPP RFCs - This is a reference to the EPP version 1.0
specifications [@!RFC5730], [@!RFC5731], [@!RFC5732] and [@!RFC5733].

Stateful EPP - The definition according to Section 2 of [@!RFC5730].

Stateless EPP or REPP - The RESTful transport for EPP described in
this document.

URL - A Uniform Resource Locator as defined in [@!RFC3986].

Resource - A network data object or service that can be identified
by a URL.

Command mapping - The mapping of [@!RFC5730] XML commands to
Stateless EPP.


# Conventions Used in This Document

XML is case sensitive.  Unless stated otherwise, XML specifications
and examples provided in this document MUST be interpreted in the
character case presented to develop a conforming implementation.


# RESTful transport for EPP or REPP

REPP is designed to solve, in the spirit of [@!RFC3375], the drawbacks
as mentioned in the next paragraph and yet maintain compatibility
with existing object mapping definitions.

The design intent is to provide a clear, clean and self-explanatory
interface that can easily be integrated with existing software
systems.  On the basis of these principles a [REST] architectural
style was chosen.  A client interacts with a REPP server via HTTP
requests.

A server implementing REPP, MUST NOT keep any client state.
Every client request needs to provide all of the information necessary 
to process the request.

REPP conforms to the EPP transport mapping considerations as defined in
[@!RFC5730], Section 2.1.  With REPP, the EPP [@!RFC5730] XML commands
are mapped to REST URL resources. Since REPP relies on a newly defined XSD
schema with protocol elements, REPP can also be referred to as
an [@!RFC5730], Section 2.7.1 protocol extension.


# Drawbacks Associated with Stateful EPP

[@!RFC5734] requires a stateful session between a client and the
EPP server.  This is accomplished by setting up a session with
a <login> and keeping it alive for some time until issuing a
<logout>.  This may pose challenges in load-balanced environments,
when a running session for whatever reason suddenly has to be
switched from one EPP server to another and state is kept on a per
server basis.

[@!RFC5734] EPP sessions can wind up in a state where they are no
longer linked to an active TCP connection, especially in an
environment where TCP connectivity is flaky.  This may raise problems
in situations where session limits are enforced.

REPP is designed to avoid these drawbacks, hence making the
interaction between an EPP client and an EPP server more robust and
efficient.


# EPP Extension Framework

According to [@!RFC3735], Section 2, EPP provides an extension
framework that allows features to be added at the protocol, object,
and command-response levels. REPP affects the
following levels:

Protocol extension:  REPP defines a new namespace
"urn:ietf:params:xml:ns:restful-epp-1.0".  It declares new
elements, which MUST be used for REPP.  The root element
for the new namespace is the <repp> element.  This element MUST
contain an object mapping defined by the object mapping schemas.

Object extension:  REPP does not define any new object level
extensions.  The existing object level extensions can be reused.
However, any existing object mapping element, including any added
extension elements it might contain, SHALL be added as a child to
the new <repp> element.

Command-Response extension:  REPP does not use the "command"
concept, because the 'command' concept is part of a RPC style and
not a RESTful style.  A REST URL and HTTP method combination have
replaced the command structure.  All command extensions can be
reused as a rest extension.

<!--TODO:  do we need response extension and need to ad command rsp under <repp> ?-->
REPP reuses the existing response messages defined in the
EPP RFCs.  The EPP response MUST be added to the standard <epp>
element and SHALL NOT be part of any <repp> element.

The DNSSEC [@!RFC5910], E.164 number [@!RFC4114] and ENUM validation
information [@!RFC5076] extension mapping elements can be added as
children of the <repp> element.

# Resource Naming Convention

A resource can be a single uniquely object identifier e.g. a domain
name, or a collection of objects.  The complete set of objects a
client can use in registry operations MUST be identified by {context-
root}/{version}/{collection}

o  {context-root} is the base URL which MUST be specified by each
  registry. The {context-root} MAY be an empty, zero length string.

o  {version} is a label which identifies the interface version.  This
  is the equivalent of the <version> element in the EPP RFCs.

o  {collection} MUST be substituted by "domains", "hosts" or
  "contacts", referring to either [@!RFC5731], [@!RFC5732] or [@!RFC5733].

o  A trailing slash MAY be added to each request.  Implementations
  MUST consider requests which only differ with respect to this
  trailing slash as identical.

A specific object instance MUST be identified by {context-root}/
{version}/{collection}/{id} where {id} is a unique object identifier
described in EPP RFCs.

An example domain name resource following this naming convention,
would look like this:

/rest/v1/domains/example.com

The level below a collection MUST be used to identify an object
instance, the level below an object instance MUST be used to identify
attributes of the object instance.

<!--TODO ISSUE 7: No need for XML payload for GET requests when URL identifies object -->
With REPP the object identifiers are embedded in URLs.  This
makes any object identifier in the request messages superfluous.
However, since the goal of REPP is to stay compatible with the
existing EPP object mapping schemas, this redundancy is accepted as a
trade off.  Removing the object identifier from the request message
would require new object mapping schemas.

The server MUST return HTTP Status-Code 412 when the object
identifier (for example <domain:name>, <host:name> or <contact:id>)
in the HTTP message-body does not match the {id} object identifier in the URL.


# Message Exchange

A [@!RFC5730] XML request includes a command- and object mapping to which a
command must be applied.  With REPP XML request messages are expressed by using 
a combination of a URL resource and an HTTP method.

Data (payload) belonging to a request or response is added to the HTTP message-
body or sent as using an HTTP header, depending on the nature of the
request as defined in Section 9. <!--TODO: correct section number -->

<!--TODO ISSUE 10: allow for out of order processing -->
An HTTP request MUST contain no more than one EPP command.  HTTP
requests MUST be processed independently of each other and in the
same order as the server receives them.


## HTTP Method Definition

The operations on resources MUST be performed by using an HTTP method. The
server MUST support the following "verbs" ([@!REST]).

GET:  Request a representation of a resource or a collection of resources.

PUT:  Update an existing resource.

POST:  Create a new resource.

DELETE:  Delete an existing resource.

HEAD:  Check for the existence of a resource.

OPTIONS:  Request a greeting.


The server MUST not support the following "verbs"

PATCH:  Partial updating of a resource is MUST not be allowed.


## REPP Request

### EPP Data

<!--TODO ISSUE 4: also include authentication header here? -->
The payload data for a REPP request MAY be transmitted to the
server using the POST, PUT and GET HTTP methods.

POST and PUT:  Payload data, when required, MUST be added to the
  message-body.

GET:  When payload data is required, it concerns <authInfo>.  This
  SHALL be put in the "X-REPP-authinfo" HTTP request-header.


### REPP Request Headers

HTTP request-headers are used to transmit additional or optional
request data to the server.  All REPP HTTP headers must have
the "X-REPP-" prefix.

X-REPP-cltrid:  The client transaction identifier is the equivalent
  of the <clTRID> element in the EPP RFCs and MUST be used
  accordingly.  When this header is present in a client request, an
  equivalent element in the message-body MAY also be present, but
  MUST than be consistent with the header.

<!--TODO ISSUE 9: How to handle authInfo data for INFO command (GET request) -->
X-REPP-authinfo:  The X-REPP-authinfo request-header is the
  alternative of the <authInfo> element in the EPP RFCs and MUST be
  used accordingly.  It MUST contain the entire authorization
  information element as mentioned in Section 11.1.


### Generic HTTP Headers

Generic HTTP headers MAY be used as defined in HTTP/1.1 [@!RFC2616].  For
REPP, the following general-headers are REQUIRED in HTTP requests.

Accept-Language:  This request-header is equivalent to the <lang>
  element in the EPP <login> command, expect that the usage of this
  header by the client is OPTIONAL.  The server MUST support the use
  of HTTP Accept-Language header in client requests.  The client MAY
  issue a <hello> to discover the languages known by the server.
  Multiple servers in a load-balanced environment SHOULD reply with
  consistent <lang> elements in a <greeting>.  Clients SHOULD NOT
  expect that obtained <lang> information remains consistent between
  different requests.  Languages not supported by the server default
  to "en".

  <!--TODO ISSUE 6:Allow for additional dataformat -->    

Content-Type: ...


## REPP Response

The server response is made up out of a HTTP Status-Code, HTTP
response-headers and it MAY contain an EPP XML message in the HTTP
message-body.

### REPP Response Headers

HTTP response-headers are used to transmit additional response data
to the client.  All REPP HTTP headers must have the "X-REPP-"
prefix.

X-REPP-svtrid:  This header is the equivalent of the <svTRID> element
  in the EPP RFCs and MUST be used accordingly.  If an HTTP message-
  body with the EPP XML equivalent <svTRID> exists, both values MUST
  be consistent.

X-REPP-cltrid:  This header is the equivalent of the <clTRID> element
  in the EPP RFCs and MUST be used accordingly.  If an HTTP message-
  body with the EPP XML equivalent <clTRID> exists, both values MUST
  be consistent.

X-REPP-eppcode:  This header is the equivalent of the <result code>
  element in te EPP RFCs and MUST be used accordingly. If an HTTP
  message-body with The EPP XML equivalent <result code> exists,
  both values MUST be consistent.

X-REPP-avail:  The EPP avail header is the alternative of the "avail"
  attribute of the <object:name> element in a check response and
  MUST be used accordingly.


### Generic Headers

Generic HTTP headers MAY be used as defined in HTTP/1.1 [@!RFC2616]. For
REPP, the following general-headers are REQUIRED in HTTP responses.

  <!--TODO ISSUE 10: How to handle caching -->   
Cache-Control:  ...  TBD: the idea is to prohibit
  caching.  Even though it will probably work and be useful in some
  scenario's, it also complicates matters.]

  <!--TODO ISSUE 11: How to handle connections -->   
Connection:  ....


 ## Error Handling

REPP is designed atop of the HTTP protocol, both are an
application layer protocol with their own status- and result codes.
The value of an EPP result code and HTTP Status-Code MUST remain
independent of each other.  E.g. an EPP result code indicating an
error can be combined with an HTTP request with Status-Code 200.

HTTP Status-Code:  MUST only return status information related to the
  HTTP protocol, When there is a mismatch between the object
  identifier in the HTTP message-body and the resource URL HTTP
  Status-Code 412 MUST be returned.

  The following EPP result codes specify an interface-,
  authorization-, authentication- or an internal server error and
  MUST NOT be used in REPP.  Instead, when the related error
  occurs, an HTTP Status-Code MUST be returned in accordance to the
mapping shown in Table 1.

EPP result code:  MUST only return EPP result information relating to
  the EPP protocol.  The HTTP header "X-REPP-eppcode" MUST be used
  for EPP result code information.

            EPP result code and HTTP Status-Code mapping.

EPP result code     | HTTP Status-Code
--------|------
2000 unknown command     | 400
2201 authorization error   | 401
2202 Invalid authorization information | 401
2101 unimplemented command  | 501



# Command Mapping

This section describes the details of the REST interface by referring
to the [@!RFC5730] Section 2.9 Protocol Commands and defining how these
are mapped to RESTful requests.

Each RESTful operation consists of four parts: 1. the resource, 2.
the HTTP method 3. the request payload, which is the HTTP message-
body of the request, 4. the response payload, being the HTTP message-
body of the response.

Table 2 list a mapping for each EPP to REPP, the subsequent sections
provide details for each request.  Each URL in the table is prefixed
with "/repp/v1/".  To make the table fit we use the following
abbreviations:

{c}:  An abbreviation for {collection}: this MUST be substituted with
  "domains", "hosts", "contacts" or "messages".

{i}:  An abbreviation for {id}: a domain name, host name, contact id
  or a message id.

(opt):  The item is optional.

        Command mapping from EPP to REPP.

EPP command   | Method | Resource   | Request payload | Response payload
--------------|--------|------------|-----------------|-------------
Hello         | OPTIONS | /         | N/A            | <greeting>   |
Login         | N/A   |             | N/A            | N/A          |
Logout        | N/A    |            | N/A            | N/A          |
Check         | HEAD | {c}/{i}      | N/A            | N/A          |
Info          | GET | {c}/{i}       | AUTH(opt)      | <info>       |
Poll request  | GET | messages      | N/A            | <poll>       |
Poll ack      | DELETE  |  messages/{i}            | N/A            | <poll> ack   |
Transfer (query) | GET  |  {c}/{i}/transfer            | AUTH(opt)      | <transfer>   |
New password  | PUT  | password      | password       | N/A          |
Create        | POST  | {c}          | <create>       | <create>     |
Delete        | DELETE  | {c}/{i}    | N/A            | <delete>     |
Renew         | PUT | {c}/{i}/validity              | <renew>        | <renew>      |
Transfer  (create)      | POST  | {c}/{i}/transfer            | <transfer>     | <transfer>   |
Transfer (cancel)     | DELETE | {c}/{i}/transfer           | N/A            | <transfer>   |
Transfer  (approve)    | PUT | {c}/{i}/transfer               | N/A            | <transfer>   |
Transfer (reject)      | DELETE | {c}/{i}/transfer           | N/A            | <transfer>   |
Update        | PUT | {c}/{i}       | <update>       | <update>     |


## Hello

- Request: OPTIONS /repp/v1

- Request payload: N/A

- Response payload: <greeting>

The <greeting> (Section 2.4 RFC 5730) MUST NOT be automatically
transmitted by the server with each new HTTP connection.  The server
MUST send a <greeting> element in response to a OPTIONS method on the
root "/" resource.

A REPP client MUST NOT use a <hello> XML payload.


## Password

-  Request: PUT /repp/v1/password

-  Request payload: New password

-  Response payload: N/A

The client MUST use the HTTP PUT method on the password resource.
This is the equivalent of the <newPW> element in the <login> command
described in [@!RFC5730].  The request message-body MUST contain the
new password which MUST be encoded using Base64 [@!RFC4648].

After a successful password change, the HTTP header "X-REPP-eppcode"
must contain EPP result code 1000, otherwise an appropriate 2xxx
range EPP result code.

##  Session Management Resources

The server MUST NOT create a client session.  Login credentials MUST
be added to each client request.  This SHOULD be done by using any of the
available HTTP authentication mechanisms. Basic authentication MAY
be, all authentication mechanisms MUST be combined with TLS [@!RFC5246] for additional security.

To protect information exchanged between an EPP client and an EPP
server [@!RFC5734] Section 9 level of security is REQUIRED.

###  Login

The <login> command MUST NOT be implemented by a server.  The <newPW>
element has been replaced by the Password resource.  The <lang>
element has been replaced by the Accept-Language HTTP request-header.
The <svcs> element has no equivalent in RESTful EPP, the client can
use a <hello> to discover the server supported namespace URIs.  The
server MUST check every XML namespace used in client XML requests.
An unsupported namespace MUST result in the appropriate EPP result
code.

###  Logout

The <logout> command MUST NOT be implemented by the server.

## Query Resources

### Check

-  Request: HEAD {collection}/{id}

-  Request payload: N/A

-  Response payload: N/A

The HTTP header X-REPP-avail with a value of "1" or "0" is returned,
depending on whether the object can be provisioned or not.

A <check> request MUST be limited to checking only one resource {id}
at a time.  This may seem a step backwards when compared to the check
command defined in the object mapping of the EPP RFCs where multiple
object-ids are allowed inside a check command. The RESTful check operation 
can be load balanced more efficient when there is only a single resource {id}
that needs to be checked.

The server MUST NOT support any <object:reason> elements described in
the EPP object mapping RFCs.

### Info

-  Request: GET {collection}/{id}

-  Request payload: OPTIONAL X-REPP-authinfo HTTP header with
  <authInfo>.

-  Response payload: Object <info> response.

A object <info> request MUST be performed with the HTTP GET method on
a resource identifying an object instance.  The response MUST be a
response message as described in object mapping of the EPP RFCs,
possibly extended with an [@!RFC3915] extension element (<rgp:
infData>).

#### Domain Name

A domain name <info> differs from a contact- and host <info> in the
sense that EPP Domain Name Mapping [@!RFC5731], Section 3.1.2 describes
an OPTIONAL "hosts" attribute for the <domain:name> element.  This
attribute is mapped to additional REST resources to be used in a
domain name info request.

The specified default value is "all".  This default is mapped to a
shortcut, the resource object instance URL without any additional
labels.

-  default: GET domains/{id}

-  Hosts=all: GET domains/{id}/all

-  Hosts=del: GET domains/{id}/del

-  Hosts=sub: GET domains/{id}/sub

-  Hosts=none: GET domains/{id}/none

   The server MAY require the client to include additional authorization
   information. The authorization data MUST be sent with the "X-REPP-
   authinfo" HTTP request-header.

###  Poll

####  Poll Request

-  Request: GET messages/

-  Request payload: N/A

-  Response payload: Poll request response message.

A client MUST use the HTTP GET method on the messages collection to
request the message at the head of the queue.

####  Poll Ack

-  Request: DELETE messages/{id}

-  Request payload: N/A

-  Response payload: Poll ack response message

A client MUST use the HTTP DELETE method on a message instance to
remove the message from the message queue.

####  Transfer Query Op

-  Request: GET {collection}/{id}/transfer

-  Request payload: Optional X-REPP-authinfo HTTP header with
  <authInfo>

-  Response payload: Transfer query response message.

A <transfer> query MUST be performed with the HTTP GET method on the
transfer resource of a specific object instance.





# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


# Acknowledgments

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
