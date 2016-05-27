<h3 align="center">
  <img src="https://raw.githubusercontent.com/mrackwitz/Inboxly/assets/curly-appicon.png" alt="Inboxly Logo" />
</h3>

# Inboxly
### A little demo how to build a **Reactive App** using [**Realm**](https://realm.io)

![](https://raw.githubusercontent.com/mrackwitz/Inboxly/assets/favorites.gif)

## Where to start?

The [`master`](https://github.com/mrackwitz/Inboxly/tree/master) branch contains the final state.
If you want to go through this tutorial app yourself, start over at [`001_start`](https://github.com/mrackwitz/Inboxly/tree/001_start).

On this branch all Realm-related functionality is ripped out. What remains is just the boilerplate code around setting up view controllers and views.

There are further branches you can follow along. The features, as seen in the source code by TODOs at the beginning of each file are implemented in the following order:

1. Fetch data from the `InboxlyAPI` in the `DataController`.
2. Implement the `FeedTableViewController` and the `FeedTableViewCell` to show messages on the stream.
3. Implement the `CacheController` to (fake) download images.
4. Let the `FeedTableViewCell` observe for photos, which were downloaded, to display them as soon as they are available while the cell is configured.

There are further steps beyond this to match the final state, which are left open as an exercise.

### Notes

The solutions implemented here were used for exemplary purposes and shouldn't necessarily re-applied for real-world use-cases. For example it won't be a good idea to download an image, load it into memory with `UIImage`, get its png representation, persist that into your database, discard it from memory, just to reload it all over again once it should be displayed.
Instead you should achieve far better performance by relying on a proven third-party image caching framework like  [HanekeSwift](https://github.com/Haneke/HanekeSwift),
[FastImageCache](https://github.com/path/FastImageCache), [SDWebImage](https://github.com/rs/SDWebImage) [or one of the many, many others.](https://cocoapods.org/?q=image%20cache)

## Credits

This app was developed by [**Marin Todorov**](https://github.com/icanzilb) & [**Marius Rackwitz**](https://github.com/mrackwitz).
