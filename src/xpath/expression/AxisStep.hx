/* haXe XPath by Daniel J. Cassidy <mail@danielcassidy.me.uk>
 * Dedicated to the Public Domain
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS 
 * OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED 
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 * GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 * NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */


package xpath.expression;
import xpath.expression.PathStep;
import dcxml.Xml;
import xpath.context.Context;
import xpath.token.AxisToken;
import xpath.type.XPathString;


class AxisStep extends PathStep {
	
	private var axis:AxisEnum;
	
	
	public function new (axis:AxisEnum, ?next:PathStep) {
		super(this, next);
		this.axis = axis;
	}
	
	private function step (context:Context) :Array<Xml> {
		var selected:Array<Xml> = new Array<Xml>();
		
		switch(axis) {
			case Ancestor:
			var node:Xml = context.node.parent;
			while (node != null) {
				selected.push(node);
				node = node.parent;
			}
		
			case AncestorOrSelf:
			var node:Xml = context.node;
			while (node != null) {
				selected.push(node);
				node = node.parent;
			}
			
			case Attribute:
			for (attr in context.node.attributes()) {
				selected.push(attr);
			}
			
			case Child:
			var node:Xml = context.node.firstChild;
			while (node != null) {
				selected.push(node);
				node = node.nextSibling;
			}
			
			case Descendant:
			var descent:Int = 1;
			var parent:Xml = null;
			var next:Xml = context.node.firstChild;
			while (true) {
				while (next != null) {
					selected.push(next);
					parent = next;
					next = next.firstChild;
					++descent;
				}
				if (--descent <= 0) break;
				next = parent.nextSibling;
				parent = parent.parent;
			}
			
			case DescendantOrSelf:
			selected.push(context.node);
			var descent:Int = 1;
			var parent:Xml = null;
			var next:Xml = context.node.firstChild;
			while (true) {
				while (next != null) {
					selected.push(next);
					parent = next;
					next = next.firstChild;
					++descent;
				}
				if (--descent <= 0) break;
				next = parent.nextSibling;
				parent = parent.parent;
			}
			
			case Following:
			var node:Xml = context.node.getNode(1);
			while (node != null) {
				selected.push(node);
				node = node.getNode(1);
			}
			
			case FollowingSibling:
			var node:Xml = context.node.nextSibling;
			while (node != null) {
				selected.push(node);
				node = node.nextSibling;
			}
			
			case Namespace:
			// TODO
			throw "not implemented";
			
			case Parent:
			if (context.node.parent != null) selected.push(context.node.parent);
			
			case Preceding:
			var node:Xml = context.node.getNode(-1);
			while (node != null) {
				selected.push(node);
				node = node.getNode(-1);
			}
			
			case PrecedingSibling:
			var node:Xml = context.node.getSibling(-1);
			while (node != null) {
				selected.push(node);
				node = node.getSibling(-1);
			}
			
			case Self:
			selected.push(context.node);
		}
		
		return selected;
	}
	
}