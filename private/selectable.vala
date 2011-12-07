namespace IBus {
    public interface Selectable : Object {
        public abstract void move_cursor (IBus.MovementStep step, int count);
        public abstract void activate_selected ();
        public signal void character_activated (unichar uc);
    }
}