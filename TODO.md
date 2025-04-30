### TODO

#### Disable directory listings

- [ ] https://github.com/aaron-imbrock/snippetbox/issues/10
[Disable access to /static by implementing this blog post](https://www.alexedwards.net/blog/disable-http-fileserver-directory-listings)

#### Panic recovery in background goroutines
- [ ] https://github.com/aaron-imbrock/snippetbox/issues/12

### Done

- [x] https://github.com/aaron-imbrock/snippetbox/pull/9
- #### Pin and download dependencies
```
go mod tidy -e
go mod vendor
```
