//
//  Follower.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 23/04/24.
//

import Foundation

struct Follower: Codable {
  var login: String
  /* avatar_url(original json response) - Codable automatically(?) converts snake case to camel case, for swift best practices. it didn't work, if you use, for instance, avatarNameUrl.
  
   if login/avatar_url can come back null and i don't make these optional, it's going to crash the app. i'm not making these optional, 'cause i know login/avatar_url aren't going to be null. for a user to exist, they have to have a login and an avatar url and/or github will provide one avatar for default.
   */
  var avatarUrl: String
}



// https://docs.github.com/en/rest/users/followers?apiVersion=2022-11-28

/*

[
  {
    "login": "octocat",
    "id": 1,
    "node_id": "MDQ6VXNlcjE=",
    "avatar_url": "https://github.com/images/error/octocat_happy.gif",
    "gravatar_id": "",
    "url": "https://api.github.com/users/octocat",
    "html_url": "https://github.com/octocat",
    "followers_url": "https://api.github.com/users/octocat/followers",
    "following_url": "https://api.github.com/users/octocat/following{/other_user}",
    "gists_url": "https://api.github.com/users/octocat/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/octocat/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/octocat/subscriptions",
    "organizations_url": "https://api.github.com/users/octocat/orgs",
    "repos_url": "https://api.github.com/users/octocat/repos",
    "events_url": "https://api.github.com/users/octocat/events{/privacy}",
    "received_events_url": "https://api.github.com/users/octocat/received_events",
    "type": "User",
    "site_admin": false
  }
]

*/
