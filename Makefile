S3_BUCKET ?= neiybor-public

.PHONY: build build-heroku-20 sync

build: build-heroku-20

build-heroku-20:
	@docker pull heroku/heroku:20-build
	@docker run -v "$(shell pwd)":/buildpack --rm -it -e "STACK=heroku-20" heroku/heroku:20-build /buildpack/scripts/build_ngx_mruby.sh

sync:
	@echo "Performing dry run of sync to $(S3_BUCKET)..."
	@echo
	@aws s3 sync archives/ s3://$(S3_BUCKET)/archives --dryrun
	@echo
	@read -p "Continue with sync? [y/N]? " answer && [ "$$answer" = "y" ]
	@echo
	@aws s3 sync archives/ s3://$(S3_BUCKET)/archives
