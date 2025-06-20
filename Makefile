DOCSDIR = docs
SRC = src
SCHEMAS = cohra2 ada_ohwb

COHRA2_SCHEMA_DIR = $(SRC)/schema
COHRA2_SCHEMA = $(COHRA2_SCHEMA_DIR)/cohra2.yaml
COHRA2_DOCS_DIR = $(DOCSDIR)/cohra2

ADA_OHWB_SCHEMA = $(SRC)/schema/ada_ohwb.yaml
ADA_OHWB_DOCS_DIR = $(DOCSDIR)/ada_ohwb

# --- linkml products --- #
cohra2-jsonschema: $(COHRA2_SCHEMA)
	gen-json-schema $< > jsonschema/cohra2.json

cohra2-owl: $(COHRA2_SCHEMA)
	gen-owl $< > temp/cohra2.tmp.ttl 
	src/scripts/pun-annotations-to-ttl.py $< > temp/pun.tmp.ttl 
	robot merge -i temp/cohra2.tmp.ttl -i temp/pun.tmp.ttl -o owl/cohra2.ttl 

## remove products
clean-products:
# don't delete README files
	find jsonschema/ -type f -not -name 'README.md' -delete     
	find jsonld/ -type f -not -name 'README.md' -delete     
	find jsonld-context/ -type f -not -name 'README.md' -delete     
	find shacl/ -type f -not -name 'README.md' -delete     
	find owl/ -type f -not -name 'README.md' -delete     

# --- schema documentation --- #
gendoc-%:
	gen-doc -d $(DOCSDIR)/$* $(SRC)/schema/$*.yaml

gendoc-all: $(SCHEMAS:%=gendoc-%)

gendoc: gendoc-all
	@mkdir -p docs/images
	@if [ -n "$(wildcard src/docs/*.md)" ]; then cp src/docs/*.md docs/; fi
	@if [ -n "$(wildcard src/docs/images/*.*)" ]; then cp src/docs/images/*.* docs/images; fi

## remove docs
clean-docs:
# don't delete README files
	find docs/ -type f -not -name 'README.md' -delete     
	find docs/images/ -type f -not -name 'README.md' -delete     

.PHONY: gendoc gendoc-all gendoc-cohra2 gendoc-ada_ohwb clean-products clean-docs cohra2-jsonschema cohra2-owl
