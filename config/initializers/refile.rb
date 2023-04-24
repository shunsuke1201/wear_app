require "refile/s3"

aws = {
  access_key_id: "569295656239",
  secret_access_key: "&gA47_2v",
  region: "ap-northeast-1",
  bucket: "vintage-holic",
}
Refile.cache = Refile::S3.new(prefix: "cache", **aws)
Refile.store = Refile::S3.new(prefix: "store", **aws)