defmodule Hits.Validate do
  @doc """
  Validate GitHub user/org and repository name (Strings).
  """

  # ^[[:alnum:]-_.]+$ means the name is composed of
  # one or multiple alphanumeric character
  # or "-_." characters
  def repository_valid?(repo), do: String.match?(repo, ~r/^[[:alnum:]\-_.]+$/)

  # see: https://github.com/dwyl/hits/issues/154
  # alphanumeric follow by one or zero "-" or just alphanumerics
  def user_valid?(user), do: String.match?(user, ~r/^([[:alnum:]]+-)*[[:alnum:]]+$/)
end
