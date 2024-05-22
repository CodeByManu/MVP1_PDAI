from Include import *

conn = sqlite3.connect('example.db')
c = conn.cursor()

class ChangeUser(Screen):
    def __init__(self, user,**kwargs):
        super(ChangeUser, self).__init__(**kwargs)
        self.user = user
        layout = BoxLayout(orientation='vertical')
        layout.add_widget(Label(text='Change User'))
        layout.add_widget(Label(text='Name:'))
        self.name_input = TextInput(multiline=False)
        layout.add_widget(self.name_input)
        layout.add_widget(Label(text='Email:'))
        self.email = TextInput(multiline=False)
        layout.add_widget(self.email)
        btn = Button(text='Save', on_press=self.save)
        layout.add_widget(btn)
        btn = Button(text='Back', on_press=self.back)
        layout.add_widget(btn)
        self.add_widget(layout)
    
    def save(self, instance):
        name = self.name_input.text
        email = self.email.text

        # Ejecuta un comando SQL para actualizar los datos del usuario
        c.execute("UPDATE users SET name = ?, email = ? WHERE name = ? AND email = ?", (name, email, self.user.name, self.user.email))

        # Guarda los cambios y cierra la conexión a la base de datos
        conn.commit()
    
    def back(self, instance):
        App.get_running_app().root.current = 'setup'


class ChangePreferences(Screen):
    def __init__(self, **kwargs):
        super(ChangePreferences, self).__init__(**kwargs)
        layout = BoxLayout(orientation='vertical')
        layout.add_widget(Label(text='Change Preferences'))
        layout.add_widget(Label(text='Language:'))
        self.language = TextInput(multiline=False)
        layout.add_widget(self.language)
        layout.add_widget(Label(text='Theme:'))
        self.theme = TextInput(multiline=False)
        layout.add_widget(self.theme)
        btn = Button(text='Save', on_press=self.save)
        layout.add_widget(btn)
        btn = Button(text='Back', on_press=self.back)
        layout.add_widget(btn)
        self.add_widget(layout)
    
    def save(self, instance):
        language = self.language.text
        theme = self.theme.text
        # Ejecuta un comando SQL para actualizar las preferencias del usuario
        c.execute("UPDATE preferences SET language = ?, theme = ? WHERE user_id = ?", (language, theme, 1))
        # Guarda los cambios y cierra la conexión a la base de datos
        conn.commit()
    
    def back(self, instance):
        App.get_running_app().root.current = 'setup'



class SetupScreen(Screen):
    def __init__(self,us,sm, **kwargs):
        super(SetupScreen, self).__init__(**kwargs)
        self.sm = sm
        layout = BoxLayout(orientation='vertical')
        self.user = us
        layout.add_widget(Label(text='User Settings'))
        layouth = BoxLayout(orientation='horizontal')
        layouth.add_widget(Label(text='Name:'))
        layouth.add_widget(Label(text=self.user.name))
        layout.add_widget(layouth)
        layouth = BoxLayout(orientation='horizontal')
        layouth.add_widget(Label(text='Email:'))
        layouth.add_widget(Label(text=self.user.email))
        layout.add_widget(layouth)
        #self.name_input = TextInput(multiline=False)
        #layout.add_widget(self.name_input)

        #layout.add_widget(Label(text='Email:'))
        #self.email = TextInput(multiline=False)
        #layout.add_widget(self.email)

        #btn = Button(text='Save', on_press=self.save)
        
        layouth = BoxLayout(orientation='horizontal')
        #layouth.add_widget(btn)
        btn = Button(text='Change User', on_press=self.change_user)
        layouth.add_widget(btn)

        btn = Button(text='Back', on_press=self.back)
        layouth.add_widget(btn)
        layout.add_widget(layouth)
        self.add_widget(layout)
    
    def change_user(self, instance):
        self.sm.add_widget(ChangeUser(name = 'change_user', user = self.user))
        App.get_running_app().root.current = 'change_user'
    
    def back(self, instance):
        App.get_running_app().root.current = 'main'