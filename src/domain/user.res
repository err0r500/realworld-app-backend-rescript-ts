@genType type name = Name(string)
@genType let name = s => Name(s)
let unName = n => {
  let Name(x) = n
  x
}

type email = Email(string)
@genType let email = s => Email(s)
let unEmail = n => {
  let Email(x) = n
  x
}

type password = Password(string)
@genType let password = s => Password(s)
let unPassword = n => {
  let Password(x) = n
  x
}

type bio = Bio(option<string>)

type imageLink = ImageLink(option<string>)

@genType
type t = {name: name, email: email, password: password, bio: bio, imageLink: imageLink}
