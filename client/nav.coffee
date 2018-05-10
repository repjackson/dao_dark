
# Template.left_sidebar.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.context.example .ui.left.sidebar')
#                     .sidebar({
#                         context: $('.context.example .bottom.segment')
#                         dimPage: false
#                         transition:  'push'
#                     })
#                     .sidebar('attach events', '.context.example .menu .toggle_left_sidebar.item')
#             , 750
            
# Template.right_sidebar.onRendered ->
#     @autorun =>
#         if @subscriptionsReady()
#             Meteor.setTimeout ->
#                 $('.context.example .ui.right.sidebar')
#                     .sidebar({
#                         context: $('.context.example .bottom.segment')
#                         dimPage: false
#                         transition:  'push'
#                     })
#                     .sidebar('attach events', '.toggle_right_sidebar.item')
#                     # .sidebar('attach events', '.context.example .menu .toggle_left_sidebar.item')
#             , 1500
            
            
