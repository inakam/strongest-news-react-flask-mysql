resource "aws_codecommit_repository" "emtg-framework" {
  repository_name = var.name
  description     = "エンジニア定例2020 フレームワーク回用リポジトリ"
}
