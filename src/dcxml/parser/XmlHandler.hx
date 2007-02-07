/* dcxml by Daniel J. Cassidy <mail@danielcassidy.me.uk>
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


package dcxml.parser;


/** Interface for document event handlers for XmlParser. */
interface XmlHandler {
	
	/** Receive notification of the beginning of a document. */
	public function startDocument () :Void;
	
	/** Receive notification of the end of a document. */
	public function endDocument () :Void;
	
	/** Receive notification of the beginning of an element. */
	public function startElement (name:String, attributes:Hash<String>) :Void;
	
	/** Receive notification of the end of an element. */
	public function endElement (name:String) :Void;
	
	/** Receive notification of character data. */
	public function characters (data:String) :Void;
	
	/** Receive notification of a processing instruction. */
	public function processingInstruction (target:String, data:String) :Void;
	
	/** Receive notification of a comment. */
	public function comment (data:String) :Void;
	
	/** Receive notification of the start of a CDATA section. */
	public function startCData () :Void;
	
	/** Receive notification of the end of a CDATA section. */
	public function endCData () :Void;
	
}