S3_DIST_BUCKET:="wb-cmd-ops-s3-dist"

LAMBDA_RUNNER_ZIP:="modules/runners/lambdas/runners/runners.zip"
LAMBDA_WEBHOOK_ZIP:="modules/webhook/lambdas/webhook/webhook.zip"
LAMBDA_SYNCER_ZIP:="modules/runner-binaries-syncer/lambdas/runner-binaries-syncer/runner-binaries-syncer.zip"

S3_RUNNER_ZIP:="ops-github-runners/runners.zip"
S3_WEBHOOK_ZIP:="ops-github-runners/webhook.zip"
S3_SYNCER_ZIP:="ops-github-runners/runner-binaries-syncer.zip"

build:
	+$(MAKE) dist -C modules/runners/lambdas/runners
	+$(MAKE) dist -C modules/runner-binaries-syncer/lambdas/runner-binaries-syncer
	+$(MAKE) dist -C modules/webhook/lambdas/webhook

dist:
	@echo "Writing runner zip to S3"
	@aws s3 cp ${LAMBDA_RUNNER_ZIP} s3://${S3_DIST_BUCKET}/${S3_RUNNER_ZIP}
	@echo "Writing webhook zip to S3"
	@aws s3 cp ${LAMBDA_WEBHOOK_ZIP} s3://${S3_DIST_BUCKET}/${S3_WEBHOOK_ZIP}
	@echo "Writing syncer zip to S3"
	@aws s3 cp ${LAMBDA_SYNCER_ZIP} s3://${S3_DIST_BUCKET}/${S3_SYNCER_ZIP}

	@echo "List latest runner zip object version runners_lambda_s3_object_version"
	@aws s3api list-object-versions --bucket ${S3_DIST_BUCKET} --prefix ${S3_RUNNER_ZIP} --query 'Versions[?IsLatest].[VersionId]' --output text
	@echo "List latest webhook zip object version for webhook_lambda_s3_object_version"
	@aws s3api list-object-versions --bucket ${S3_DIST_BUCKET} --prefix ${S3_WEBHOOK_ZIP} --query 'Versions[?IsLatest].[VersionId]' --output text
	@echo "List latest syncer zip object version for syncer_lambda_s3_object_version"
	@aws s3api list-object-versions --bucket ${S3_DIST_BUCKET} --prefix ${S3_SYNCER_ZIP} --query 'Versions[?IsLatest].[VersionId]' --output text