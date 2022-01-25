using StackExchange.Redis;

// source: https://docs.microsoft.com/en-us/learn/modules/develop-for-azure-cache-for-redis/4-interact-redis-api

var connectionString = "[cache-name].redis.cache.windows.net:6380,password=[password-here],ssl=True,abortConnect=False";
var redisConnection = ConnectionMultiplexer.Connect(connectionString);

IDatabase db = redisConnection.GetDatabase();

// storing a key/value in the cache
bool wasSet = db.StringSet("favorite:flavor", "i-love-rocky-road");

// StringSet method returns a bool indicating whether the value was set (true) or not (false).
string value = db.StringGet("favorite:flavor");
Console.WriteLine(value); // displays: ""i-love-rocky-road""