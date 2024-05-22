from Include import *


class AddActivityScreen(Screen):
    def __init__(self, **kwargs):
        super(AddActivityScreen, self).__init__(**kwargs)
        
        layout = BoxLayout(orientation='vertical')

        layout.add_widget(Label(text='Add Activity'))

        layout.add_widget(Label(text='Activity Name:'))
        self.activity_name = TextInput(multiline=False)
        layout.add_widget(self.activity_name)

        layout.add_widget(Label(text='Activity Description:'))
        self.activity_description = TextInput(multiline=False)
        layout.add_widget(self.activity_description)

        layout.add_widget(Label(text='Activity Date:'))
        self.activity_date = TextInput(multiline=False)
        layout.add_widget(self.activity_date)

        layout.add_widget(Label(text='Activity Time:'))
        self.activity_time = TextInput(multiline=False)
        layout.add_widget(self.activity_time)

        layouth = BoxLayout(orientation='horizontal')
        btn = Button(text='Add Activity', on_press=self.add_activity)
        layouth.add_widget(btn)

        btn = Button(text='Back', on_press=self.back)
        layouth.add_widget(btn)
        layout.add_widget(layouth)
        self.add_widget(layout)

    def add_activity(self, instance):
        print(f"Activity Name: {self.activity_name.text}")
        print(f"Activity Description: {self.activity_description.text}")
        print(f"Activity Date: {self.activity_date.text}")
        print(f"Activity Time: {self.activity_time.text}")
        App.get_running_app().root.current = 'main'
    
    def back(self, instance):
        App.get_running_app().root.current = 'main'