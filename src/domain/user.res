type name = Name(string)
@genType let name = s => Name(s)

type email = Email(string)
@genType let email = s => Email(s)

type password = Password(string)
@genType let password = s => Password(s)

type bio = Bio(option<string>)

type imageLink = ImageLink(option<string>)

@genType
type t = {name: name, email: email, password: password, bio: bio, imageLink: imageLink}
