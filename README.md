# Elm exercises

In these exercises you'll implement the [`List`](https://github.com/elm/core/blob/master/src/List.elm) module from Elm core and Kris Jenkins' [`RemoteData`](https://github.com/krisajenkins/remotedata) module.

The tests are copied from these two projects.
The implementations of the functions have been replaced with dummy values and it's your job to fix them so that the tests pass.
Ideally I'd like to use `Debug.todo`s instead of dummy values but that caused a lot of noise when running the tests. Note to self: make an SSSCE and open an issue on this.

## How

Run tests in watch mode with `npm test -- --watch`.

Protip: use [`Test.only`](https://package.elm-lang.org/packages/elm-explorations/test/latest/Test#only) or [`Test.skip`](https://package.elm-lang.org/packages/elm-explorations/test/latest/Test#skip) to run only the tests you care about while working on a specific function.
