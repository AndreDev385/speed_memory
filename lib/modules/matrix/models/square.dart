/// Represents the state of a square in the matrix.
/// A square can be either Active or Inactive.
sealed class Square {
  const Square();
}

/// An active square.
class Active extends Square {
  const Active();
}

/// An inactive square.
class Inactive extends Square {
  const Inactive();
}
