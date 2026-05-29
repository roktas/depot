# Commit Examples

Load this reference when the user wants examples, asks why a commit message is invalid, or needs help choosing between similar commit messages.

## Scope Examples

```
feat(parser): add ability to parse arrays
fix(auth): resolve token expiration issue
docs(readme): update installation instructions
```

## Breaking Changes

Using `!`:

```
feat!: send an email to the customer when a product is shipped
feat(api)!: send an email to the customer when a product is shipped
```

Using a footer:

```
feat: allow provided config object to extend other configs

BREAKING CHANGE: `extends` key in config file is now used for extending other config files
```

Using both:

```
chore!: drop support for Node 6

BREAKING CHANGE: use JavaScript features not available in Node 6.
```

## More Examples

```
feat!: migrate to new API client

BREAKING CHANGE: The API client interface has changed. All methods now
return Promises instead of using callbacks.
```

```
docs: correct spelling of CHANGELOG
```

```
fix: prevent racing of requests

Introduce a request id and a reference to latest request. Dismiss
incoming responses other than from latest request.

Remove timeouts which were used to mitigate the racing issue but are
obsolete now.

Reviewed-by: Z
Refs: #123
```

## Common Mistakes

- Bad: `Added new feature`
- Good: `feat: add new feature`
- Bad: `fix: bug`
- Good: `fix: resolve null pointer exception in user service`
- Bad: `feat: add feature`
- Good: `feat: add user profile page`
- Bad: `feat: Added OAuth support.`
- Good: `feat: add OAuth support`
