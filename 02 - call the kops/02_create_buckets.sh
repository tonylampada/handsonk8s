aws s3api create-bucket \
    --bucket $STATEBUCKET \
    --create-bucket-configuration LocationConstraint=${AWS_REGION} \
    --region ${AWS_REGION}

aws s3api create-bucket \
    --bucket ${OIDCBUCKET} \
    --create-bucket-configuration LocationConstraint=${AWS_REGION} \
    --region ${AWS_REGION} \
    --acl public-read