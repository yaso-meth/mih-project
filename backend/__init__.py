# from supertokens_python import init, InputAppInfo, SupertokensConfig
# from supertokens_python.recipe import emailpassword, session, dashboard

# init(
#     app_info=InputAppInfo(
#         app_name="MIH_API_HUB",
#         api_domain="http://localhost:8080/",
#         website_domain="http://mzansi-innovation-hub.co.za",
#         api_base_path="/auth",
#         website_base_path="/auth"
#     ),
#     supertokens_config=SupertokensConfig(
#         # https://try.supertokens.com is for demo purposes. Replace this with the address of your core instance (sign up on supertokens.com), or self host a core.
#         connection_uri="supertokens:3567/",
#         api_key="leatucczyixqwkqqdrhayiwzeofkltds"
#     ),
#     framework='fastapi',
#     recipe_list=[
#         # SuperTokens.init(),
#         session.init(), # initializes session features
#         emailpassword.init(),
#         dashboard.init(admins=[
#             "yasienmeth@gmail.com",
#           ],
#         )
#     ],
#     mode='wsgi' # use wsgi instead of asgi if you are running using gunicorn
# )