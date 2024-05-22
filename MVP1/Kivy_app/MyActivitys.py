from Include import *

class MyActivitys(Screen):
    def __init__(self, **kwargs):
        super(MyActivitys, self).__init__(**kwargs)
        layout = BoxLayout(orientation='vertical')

        layout.add_widget(Label(text='My Activitys'))

        self.add_widget(layout)
        btn = Button(text='Back', on_press=self.back)
        layout.add_widget(btn)
    

    def back(self, instance):
        App.get_running_app().root.current = 'main'