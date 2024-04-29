//
//  User.swift
//  GitHubFollowers
//
//  Created by Elizeu RS on 23/04/24.
//

import Foundation

struct User: Codable {
  var login: String
  var avatarUrl: String
  // name - that's optional, you don't have to put that. when it does come back null, we'll be able to handle that.
  var name: String?
  // location - optional too. they might not put their location.
  var location: String?
  var bio: String?
  // not optional, 'cause, if they don't have any, it's going to be a zero, so it's always going to be something.
  var publicRepos: Int
  var pubblicGists: Int
  var htmlUrl: String
  var following: Int
  var followers: Int
  var createdAt: String
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