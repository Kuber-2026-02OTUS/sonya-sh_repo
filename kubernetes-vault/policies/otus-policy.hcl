path "otus/cred" {
  capabilities = ["read", "list"]
}

path "otus/*" {
  capabilities = ["list"]
}
