from Include import *

class CalendarScreen(Screen):
    def __init__(self, **kwargs):
        super(CalendarScreen, self).__init__(**kwargs)
        layout = BoxLayout(orientation='vertical')

        layout.add_widget(Label(text='Calendar'))

        self.add_widget(layout)
        btn = Button(text='Back', on_press=self.back)
        layout.add_widget(btn)
    
    def back(self, instance):
        App.get_running_app().root.current = 'main'