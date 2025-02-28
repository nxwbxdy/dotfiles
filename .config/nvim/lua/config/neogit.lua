require 'neogit'.setup {
  graph_style = 'unicode',
  git_services = {
    ["gitlab.fh-ooe.aat"] = "https://gitlab.fh-ooe.at/${owner}/${repository}/merge_requests/new?merge_request[source_branch]=${branch_name}",
  }
}
