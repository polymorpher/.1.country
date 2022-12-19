By Aaron Li [@polymorpher](https://github.com/polymorpher/)

### Why is D1DC not built on ENS?

Initially, we did so and made some initial implementations. We evaluated the option of making this contract a derivative of ENS contracts, such as NameWrapper, which manages NFT, and subdomain registrars. However, the code quickly become quite complex. All developers had to become familiar with subsystems in ENS and maintain a mental model of that. The contract also becomes much harder to be understood and audited. These extra constraints prevent us from launching the product quickly and iterating fast. In the end, we took the advice to severe the connection of this contract to ENS and to design it from scratch.

### Re: D1DC v.s. ENS contracts, compatibility, use cases

I think D1DC contract is more an application than infrastructure piece like ENS: 

- It operates as third-level domains and does not intend to let people further manage subdomains and arbitrary records
- Data stored on the contract per-user is very specific and its functionality is terminal, as opposed to being a open-ended tool that lets people build more stuff on it). 

So it probably won't be productive to turn D1DC into a derivative of ENS contract, unless the product scope expands to a level so people can build things on top of the contract later. 

That said, the contract could talk and coordinate with ENS in some way. For example, in the [dot-country](https://github.com/polymorpher/dot-country) version of the implementation, the contract leaves all domain functionalities to ENS and calls ETHRegistrarController, NameWrapper, BaseRegistrar, and other ENS components, either directly or in coordination by the users. John is working on the contract (as of Dec 18, 2022) and it will be pushed to GitHub for review soon.

Note that, unlike .1.country, the dot-country version of the product is moving towards to become a piece of infrastructure, rather than a close-ended product: 

- In the coming months, it is expected that users will be able to set DNS records of domains which they rent through this contract
- The DNS records are expected to be working in both web3 and web2
- It will enable people to configure their content, showcase their profile, even construct a quick website in the coming weeks

These features make dot-country very distinguishable from the .1.country product.

### New features for D1DC contract

So, if the new features to be implemented in D1DC contract are close-ended and specific (e.g. reverse lookup), it might be the simpler to just extend D1DC contract to have that feature. If the features are a lot more open-ended (e.g. setting DNS records, resolve multi-chain addresses), and such features are already supported in ENS, the contract could defer the functionalities to ENS, or we can turn the D1DC contract to be interfaced with ENS or be made a submodule of ENS

