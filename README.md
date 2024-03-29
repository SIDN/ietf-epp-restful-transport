# RESTful EPP

This repository contains the IETF draft for a RESTful protocol mapping for EPP.  

The [draft](https://github.com/SIDN/ietf-epp-restful-transport/blob/main/src/draft-epp-restful-transport.md) is authored using [mmark](https://mmark.miek.nl/) Markdown.

For more information about why we are working on the draft, see the short [presentation](https://www.sidnlabs.nl/downloads/6L2dl6xiV5eQY61EB14wzo/a950bcb1d4979c2b56d87d1ef6b83d45/ietf-118-restfull-epp-discussion.pdf) presented at the regext working group at IETF-118.

Contributions in the form of a Pull Request are welcome.

For generated output see:   
[Plaintext](https://sidn.github.io/ietf-epp-restful-transport/draft-epp-restful-transport.txt)  
[HTML](https://sidn.github.io/ietf-epp-restful-transport/draft-epp-restful-transport.html)  
[PDF](https://sidn.github.io/ietf-epp-restful-transport/draft-epp-restful-transport.pdf)  
[XML](https://sidn.github.io/ietf-epp-restful-transport/draft-epp-restful-transport.xml)  

## Related

 [EPP-RESTful-JSON](https://github.com/SIDN/ietf-epp-restful-json) is a draft describing how EPP XML messages can be mapped to JSON

## REST

For more information about designing a good REST API, see:
- [RESTful web API design](https://learn.microsoft.com/en-us/azure/architecture/best-practices/api-design)
- [REST API Design](https://restfulapi.net/)

## Contributing

See the
[guidelines for contributions](https://github.com/SIDN/ietf-epp-restful-transport/blob/main/CONTRIBUTING.md).

Contributions can be made by creating pull requests.
The GitHub interface supports creating pull requests using the Edit (✏) button.


## Command Line Usage

Requirements:

- [mmark](https://mmark.miek.nl/)
- [xml2rfc](https://github.com/ietf-tools/xml2rfc#installation)

Formatted versions can be built using:

```
cd src
make all
```
