### TODO 

(https://github.com/aaron-imbrock/snippetbox/issues)[Direct link to the Issues page]

#### Disable directory listings

- [ ] https://github.com/aaron-imbrock/snippetbox/issues/10 Disable access to /static

#### Panic recovery in background goroutines
- [ ] https://github.com/aaron-imbrock/snippetbox/issues/12 Panic recovery in background goroutines

### Done

- [x] https://github.com/aaron-imbrock/snippetbox/pull/9
- #### Pin and download dependencies
```
go mod tidy -e
go mod vendor
```
