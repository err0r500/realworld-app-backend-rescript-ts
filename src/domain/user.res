type name = Name(string)
@genType let mkName = s => Name(s)

type email = Email(string)
@genType let email = s => Email(s)

type password = Password(string)

type bio = Bio(option<string>)

type imageLink = ImageLink(option<string>)

@genType.opaque
type t = {name: name, email: email, password: password, bio: bio, imageLink: imageLink}
