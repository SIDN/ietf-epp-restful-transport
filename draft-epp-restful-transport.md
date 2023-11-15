%%%
title = "Extensible Provisioning Protocol (EPP) RESTful Transport"
abbrev = "Domain Names"
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

This document specifies a 'RESTful trasport for EPP' (REPP) with the
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

## Overview

The goal of domain names is to provide a mechanism for naming resources
in such a way that the names are usable in different hosts, networks,
protocol families, internets, and administrative organizations.


# Introduction

TODO Introduction




# Security Considerations

TODO Security


# IANA Considerations

This document has no IANA actions.


# Acknowledgments

{backmatter}

<reference anchor="Dyer87">
  <front>
    <title>"Hesiod", Project Athena Technical Plan - Name Service</title>
    <author initials="S." surname="Dyer" fullname="S. Dyer">
      <organization/>
    </author>
    <author initials="F." surname="Hsu" fullname="F. Hsu">
      <organization/>
    </author>
    <date year="1987" month="April"/>
  </front>
  <seriesInfo name="version" value="1.9"/>
  <annotation>
    Describes the fundamentals of the Hesiod name service.
  </annotation>
</reference>

<reference anchor="IEN116" target="https://www.rfc-editor.org/ien/ien116.txt">
  <front>
    <title>Internet Name Server</title>
    <author initials="J." surname="Postel" fullname="J. Postel">
      <organization/>
    </author>
    <date year="1979" month="August"/>
  </front>
  <annotation>
    A name service obsoleted by the Domain Name System, but still in use.
  </annotation>
</reference>

<reference anchor="Quarterman86">
  <front>
    <title>Notable Computer Networks</title>
    <author initials="J." surname="Quarterman" fullname="J. Quarterman">
      <organization/>
    </author>
    <author initials="J." surname="Hoskins" fullname="J. Hoskins">
      <organization/>
    </author>
    <date year="1986" month="October"/>
  </front>
  <seriesInfo name="volume" value="29"/>
  <seriesInfo name="number" value="10"/>
  <refcontent>Communication of the ACM</refcontent>
</reference>

<reference anchor="Solomon82">
  <front>
    <title>The CSNET Name Server</title>
    <author initials="M." surname="Solomon" fullname="M. Solomon">
      <organization/>
    </author>
    <author initials="L." surname="Landweber" fullname="L. Landweber">
      <organization/>
    </author>
    <author initials="D." surname="Neuhengen" fullname="D. Neuhengen">
      <organization/>
    </author>
    <date year="1982" month="July"/>
  </front>
  <seriesInfo name="vol" value="6"/>
  <seriesInfo name="nr" value="3"/>
  <refcontent>Computer Networks</refcontent>
  <annotation>
    Describes a name service for CSNET which is independent
    from the DNS and DNS use in the CSNET.
  </annotation>
</reference>