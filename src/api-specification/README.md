# Generating code

## Modify controller template

Template will include header params in the generated code.

https://github.com/spec-first/connexion/issues/788#issuecomment-1840442504

## generate server stub

```
export OUTPUT-DIR=/tmp/epp
openapi-generator generate -i  openapi.yaml -g python-flask -o $OUTPUT-DIR  -t ./
```


