variable "bucket_name" {
	type = string
	default = "jonny-multi-purpose-bucket"
}

variable "acl_value" {
	type = string
	default = "private"
}

resource "aws_s3_bucket" "multi_purpose_bucket" {
	bucket = "${var.bucket_name}"
	acl = "${var.acl_value}"
}
