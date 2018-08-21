namespace SharedUI.Shared
{
	//
	// Aliases and mapped types to make type names more similar between Cocoa and WPF
	//

	#if ECHOES
	public using id = object;
	public class IBAction : Attribute {}
	#endif
}