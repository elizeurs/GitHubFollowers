//
//  User.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 23/04/24.
//

import Foundation

struct User: Codable {
  // the user can't alter any of the data, so in this case, these should be let
  let login: String
  let avatarUrl: String
  // name - that's optional, you don't have to put that. when it does come back null, we'll be able to handle that.
  // if can be nil, those have to be a var. so anything that's not an optional, we're going to make a let
  var name: String?
  // location - optional too. they might not put their location.
  var location: String?
  var bio: String?
  // not optional, 'cause, if they don't have any, it's going to be a zero, so it's always going to be something.
  let publicRepos: Int
  let publicGists: Int
  let htmlUrl: String
  let following: Int
  let followers: Int
  let createdAt: String
}


// https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28


/*
 
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
 "site_admin": false,
 "name": "monalisa octocat",
 "company": "GitHub",
 "blog": "https://github.com/blog",
 "location": "San Francisco",
 "email": "octocat@github.com",
 "hireable": false,
 "bio": "There once was...",
 "twitter_username": "monatheoctocat",
 "public_repos": 2,
 "public_gists": 1,
 "followers": 20,
 "following": 0,
 "created_at": "2008-01-14T04:33:35Z",
 "updated_at": "2008-01-14T04:33:35Z",
 "private_gists": 81,
 "total_private_repos": 100,
 "owned_private_repos": 100,
 "disk_usage": 10000,
 "collaborators": 8,
 "two_factor_authentication": true,
 "plan": {
 "name": "Medium",
 "space": 400,
 "private_repos": 20,
 "collaborators": 0
 }
 } 
 */
