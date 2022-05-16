open Prelude

type name = Name(string)
let mkName = s =>
  Assert.String.isNonEmptyString(s)
    ? Validation.Success(Name(s))
    : Validation.Failure(["invalid name: empty string provided"])

let unName = n => {
  let Name(x) = n
  x
}

type email = Email(string)
let mkEmail = s =>
  Assert.String.isNonEmptyString(s)
    ? Validation.Success(Email(s))
    : Validation.Failure(["invalid email: empty string provided"])

let unEmail = n => {
  let Email(x) = n
  x
}

type password = Password(string)
let mkPassord = s =>
  Assert.String.isNonEmptyString(s)
    ? Validation.Success(Password(s))
    : Validation.Failure(["invalid password: empty string provided"])

let unPassword = n => {
  let Password(x) = n
  x
}

type bio = Bio(option<string>)

type imageLink = ImageLink(option<string>)

@genType
type t = {name: name, email: email, password: password, bio: bio, imageLink: imageLink}
let makeNewUser = (name: name, email: email, password: password) => {
  name: name,
  email: email,
  password: password,
  bio: Bio(None),
  imageLink: ImageLink(None),
}
